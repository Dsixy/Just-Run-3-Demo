extends Node2D

const TILE_SIZE := 64
const ROOM_DISTANCE := 30 * TILE_SIZE
const ROOM_COORDS_TEMPLATES := [
	[
		Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2),
		Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2),
		Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2),
	],
]

@export var room_scenes: Array[PackedScene] = []
@export var road_scene: PackedScene

var rooms: Array = []
var room_coords: Array = []
var connections: Array = []

var player: BaseCharacter

func _ready():
	build_rooms()
	build_connections()
	build_roads()
	
func test():
	for room in rooms:
		room.player = player

func _on_player_enter_room(room):
	room.activate()
	
func build_rooms():
	room_coords = ROOM_COORDS_TEMPLATES.pick_random()
	
	for coord in room_coords:
		var room_scene = room_scenes.pick_random()
		var room = room_scene.instantiate()
		add_child(room)
		room.position = Vector2(coord.x, coord.y) * ROOM_DISTANCE - room.get_room_center_world_pos()
		rooms.append(room)
		room.playerEnterS.connect(_on_player_enter_room)

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
			var road = road_scene.instantiate()
			add_child(road)
			if road.has_method("set_points"):
				road.set_points(from_pos, to_pos)

	for room in rooms:
		room.build_gates()
