extends Node2D

const ROAD_WIDTH := 6
const TILE_SIZE := 64 

@onready var floorTileMap: TileMap = $Floor
@onready var wallTileMap: TileMap = $Wall

func _ready():
	pass
	#set_points(Vector2(0, 0), Vector2(0, 1024))

func take_damage(world_pos: Vector2, damage: Damage) -> void:
	return 
	
func set_points(from_pos: Vector2, to_pos: Vector2):
	if from_pos.x != to_pos.x and from_pos.y != to_pos.y:
		push_warning("Road should be horizontal or vertical only.")
		return

	var from_tile = Vector2i(round(from_pos.x / TILE_SIZE), round(from_pos.y / TILE_SIZE))
	var to_tile = Vector2i(round(to_pos.x / TILE_SIZE), round(to_pos.y / TILE_SIZE))

	var floor_coords: Array[Vector2i] = []
	var wall_coords: Array[Vector2i] = []

	if from_tile.y == to_tile.y:
		var y = from_tile.y
		var x1 = min(from_tile.x, to_tile.x)
		var x2 = max(from_tile.x, to_tile.x)

		for x in range(x1, x2 + 1):
			for offset in range(ROAD_WIDTH):
				var coord = Vector2i(x, y + offset)
				floor_coords.append(coord)

		for x in range(x1, x2 + 1):
			wall_coords.append(Vector2i(x, y - 1))
			wall_coords.append(Vector2i(x, y + ROAD_WIDTH))

	elif from_tile.x == to_tile.x:
		var x = from_tile.x
		var y1 = min(from_tile.y, to_tile.y)
		var y2 = max(from_tile.y, to_tile.y)

		for y in range(y1, y2 + 1):
			for offset in range(ROAD_WIDTH):
				var coord = Vector2i(x + offset, y)
				floor_coords.append(coord)

		for y in range(y1, y2 + 1):
			wall_coords.append(Vector2i(x - 1, y))
			wall_coords.append(Vector2i(x + ROAD_WIDTH, y))

	for coord in floor_coords:
		floorTileMap.set_cell(0, coord, 0, Vector2i(0, 0))

	for coord in wall_coords:
		wallTileMap.set_cell(0, coord, 1, Vector2i(1, 0))
