extends Node2D

const treasureBoxScene = preload("res://scene/item/treasure_box.tscn")
const spellItemScene = preload("res://scene/item/spell_item.tscn")
@onready var wallTileMap = $Wall
@onready var floorTileMap = $Floor
@export var roomSize: Vector2

const GATE_SIZE := 6
const TILE_SIZE := 64
var gateDirections: Array[bool] = [false, false, false, false]
var durability: Dictionary = {}

var player: BaseCharacter
var enemies := []
var hasActivated: bool = false

signal playerEnterS(room: Node2D)

func _ready():
	update_floor_navigation()
	load_enemies()
	
func activate():
	if not hasActivated:
		close_gate()
		generate_spoils(Vector2.ONE * 200)
		activate_enemies()
		hasActivated = true
	
func deactivate():
	generate_spoils(Vector2.ONE * 200)
	open_gate()
	
func _process(delta):
	var tile_pos = floorTileMap.local_to_map(player.global_position - global_position)
	var tile_data = floorTileMap.get_cell_tile_data(0, tile_pos)
	if tile_data:
		var buffName = tile_data.get_custom_data("buff")
		if buffName:
			var buff = GameInfo.buffDict[buffName].instantiate()
			player.add_buff(buff)

# gateDirections: [left, bottom, right, top]
func build_gates():
	var coords: Array[Vector2i] = []

	if gateDirections[0]:
		for y in range(roomSize.y / 2 - GATE_SIZE / 2, roomSize.y / 2 + GATE_SIZE / 2):
			coords.append(Vector2i(0, y))
	if gateDirections[1]:
		for x in range(roomSize.x / 2 - GATE_SIZE / 2, roomSize.x / 2 + GATE_SIZE / 2):
			coords.append(Vector2i(x, roomSize.y - 1))
	if gateDirections[2]:
		for y in range(roomSize.y / 2 - GATE_SIZE / 2, roomSize.y / 2 + GATE_SIZE / 2):
			coords.append(Vector2i(roomSize.x - 1, y))
	if gateDirections[GATE_SIZE / 2]:
		for x in range(roomSize.x / 2 - GATE_SIZE / 2, roomSize.x / 2 + GATE_SIZE / 2):
			coords.append(Vector2i(x, 0))

	for coord in coords:
		wallTileMap.set_cell(0, coord, 0, Vector2i(2, 0))
		
func get_gate_world_pos(dir: int) -> Vector2:
	var offset: Vector2

	match dir:
		0: offset = Vector2i(-1, roomSize.y / 2 - GATE_SIZE / 2) * TILE_SIZE
		1: offset = Vector2i(roomSize.x / 2 - GATE_SIZE / 2, roomSize.y) * TILE_SIZE
		2: offset = Vector2i(roomSize.x, roomSize.y / 2 - GATE_SIZE / 2) * TILE_SIZE
		3: offset = Vector2i(roomSize.x / 2 - GATE_SIZE / 2, -1) * TILE_SIZE

	return global_position + offset
	
func get_room_center_world_pos() -> Vector2:
	return global_position + Vector2(Vector2i(roomSize / 2) * TILE_SIZE)

func load_enemies():
	var enemy = preload("res://scene/enemy/duang_duang_worm.tscn").instantiate()
	add_child(enemy)
	enemy.global_position = Vector2(200, 800)
	enemy.deathS.connect(process_enemy_death)
	enemies.append(enemy)
	
func activate_enemies():
	for enemy in enemies:
		enemy.target = player
		enemy.activate()
		
func process_enemy_death(enemy: BaseEnemy):
	enemies.erase(enemy)
	if enemies.size() == 0:
		deactivate()
	
func open_gate():
	var used_cells = wallTileMap.get_used_cells(0)
	for cell in used_cells:
		var tile_id = wallTileMap.get_cell_source_id(0, cell)
		if tile_id == 2:
			wallTileMap.set_cell(0, cell, 0, Vector2i(2, 0))
			
func close_gate():
	var used_cells = wallTileMap.get_used_cells(0)
	for cell in used_cells:
		var tile_id = wallTileMap.get_cell_source_id(0, cell)
		if tile_id == 0:
			wallTileMap.set_cell(0, cell, 2, Vector2i(2, 0))
			
func generate_spoils(pos: Vector2):
	var spellItem = spellItemScene.instantiate()
	spellItem.set_spell_type(FireballSpell)
	var treasureBox = treasureBoxScene.instantiate()
	treasureBox.set_content(spellItem)
	add_child(treasureBox)
	treasureBox.position = pos
	
func update_floor_navigation():
	var wall_cells = wallTileMap.get_used_cells(0)
	for coord in wall_cells:
		set_navigation_by_coord(coord)

func set_navigation_by_coord(coord: Vector2i, state: bool=false):
	if floorTileMap.get_cell_source_id(0, coord) != -1:
		if state:
			floorTileMap.set_cell(0, coord, 0, Vector2i.ZERO)
		else:
			floorTileMap.set_cell(0, coord, 1, Vector2i.ZERO)
	
func damage_cell(pos: Vector2i, damage: Damage) -> void:
	var tile = wallTileMap.get_cell_tile_data(0, pos)
	if tile == null:
		return
	
	if tile.get_custom_data("destroyable"):
		var key := str(pos.x) + "," + str(pos.y)
		
		if not durability.has(key):
			durability[key] = tile.get_custom_data("HP")
		
		durability[key] -= damage.finalDamage
		
		if durability[key] <= 0:
			wallTileMap.erase_cell(0, pos)
			durability.erase(key)
			set_navigation_by_coord(pos, true)
		else:
			pass

func take_damage(world_pos: Vector2, damage: Damage) -> void:
	var cell = wallTileMap.local_to_map(to_local(world_pos))
	damage_cell(cell, damage)

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		playerEnterS.emit(self)
