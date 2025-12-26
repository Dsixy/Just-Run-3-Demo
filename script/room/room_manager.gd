extends Node2D

const TILE_SIZE := 64
const ROOM_DISTANCE := 50 * TILE_SIZE
const ROOM_COORDS_TEMPLATES := [
	[
		Vector2i(0, 0), Vector2i(0, 1)
	],
	#[
		#Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2),
		#Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2),
		#Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2),
	#],
]
const ROOM_TYPE_DICT:= {
	"Grass": preload("res://resources/room_set/grass.tres")
}

@export var randomGenerate: bool = true
@export var room_coords: Array = []

var rooms: Array = []
var connections: Array = []
var player: BaseCharacter
var roomType: String
var roomSet: RoomSetRes
var roomInfo: Dictionary

func _ready():
	#set_type()
	build_rooms()
	build_connections()
	build_roads()
	
func set_room_player():
	for room in rooms:
		room.player = player
		
func set_info(info: Dictionary):
	roomInfo = info
	if info["type"] in ROOM_TYPE_DICT:
		roomType = info["type"]
		roomSet = ROOM_TYPE_DICT[info["type"]]
	
func _on_player_enter_room(room):
	room.activate()
	
func build_rooms():
	if randomGenerate:
		room_coords = ROOM_COORDS_TEMPLATES.pick_random()
		
		for coord in room_coords:
			var room_scene
			if coord == Vector2i(0, 0):
				room_scene = roomSet.shopScene
			elif coord == room_coords[-1]:
				if roomInfo["has_boss"]:
					room_scene = roomSet.bossRoomScene
				else:
					room_scene = roomSet.endScene
			else:
				room_scene = roomSet.roomScene.pick_random()
				
			var room = room_scene.instantiate()
			add_child(room)
			room.position = Vector2(coord.x, coord.y) * ROOM_DISTANCE - room.get_room_center_world_pos()
			rooms.append(room)
			room.playerEnterS.connect(_on_player_enter_room)
	else:
		var children = get_children()
		for child in children:
			rooms.append(child)
			child.playerEnterS.connect(_on_player_enter_room)

func build_connections():
	var connected := [0]
	var pending := range(1, room_coords.size())

	while pending.size() > 0:
		var possible_links = []

		for c in connected:
			for p in pending:
				var diff = room_coords[p] - room_coords[c]
				if abs(diff.x) + abs(diff.y) == 1:
					possible_links.append(Vector2i(c, p))

		if possible_links.is_empty():
			break

		var link = possible_links.pick_random()
		connections.append(link)
		connected.append(link.y)
		pending.erase(link.y)
		
	var existing = {}
	for c in connections:
		existing[str(c)] = true

	for i in range(room_coords.size()):
		for diff in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var dst_pos = room_coords[i] + diff

			var j := room_coords.find(dst_pos)
			if j == -1:
				continue

			var link = Vector2i(i, j)
			var link_reverse = Vector2i(j, i)

			if existing.has(str(link)) or existing.has(str(link_reverse)):
				continue

			if randf() < 0.5:
				connections.append(link)
				existing[str(link)] = true
				

func build_roads():
	for conn in connections:
		var from_room = rooms[conn.x]
		var to_room = rooms[conn.y]
		var from_coord = room_coords[conn.x]
		var to_coord = room_coords[conn.y]
		var diff = to_coord - from_coord

		var from_pos: Vector2
		var to_pos: Vector2

		match diff:
			Vector2i(1, 0):  # 右连接
				from_room.gateDirections[2] = true
				to_room.gateDirections[0] = true
				from_pos = from_room.get_gate_world_pos(2)
				to_pos = to_room.get_gate_world_pos(0)

			Vector2i(-1, 0):  # 左连接
				from_room.gateDirections[0] = true
				to_room.gateDirections[2] = true
				from_pos = from_room.get_gate_world_pos(0)
				to_pos = to_room.get_gate_world_pos(2)

			Vector2i(0, 1):  # 下连接
				from_room.gateDirections[1] = true
				to_room.gateDirections[3] = true
				from_pos = from_room.get_gate_world_pos(1)
				to_pos = to_room.get_gate_world_pos(3)

			Vector2i(0, -1):  # 上连接
				from_room.gateDirections[3] = true
				to_room.gateDirections[1] = true
				from_pos = from_room.get_gate_world_pos(3)
				to_pos = to_room.get_gate_world_pos(1)
			_:
				continue
				
		if (from_pos.x <= to_pos.x and from_pos.y <= to_pos.y) or true:
			var road = roomSet.roadScene.instantiate()
			add_child(road)
			if road.has_method("set_points"):
				road.set_points(from_pos, to_pos)

	for room in rooms:
		room.build_gates()
