class_name ConnectionManager extends Node2D

var connections: Array = []

class Connection:
	var source: Node
	var target: Node
	var line: Line2D

	func _init(source: Node, target: Node, line: Line2D):
		self.source = source
		self.target = target
		self.line = line


func add_connection(source: Node, target: Node) -> void:
	for c in connections:
		if (c.source == source and c.target == target):
			return

	var line := Line2D.new()
	line.width = 4
	line.default_color = Color.ALICE_BLUE
	add_child(line)

	var conn = Connection.new(source, target, line)
	connections.append(conn)

func remove_connection(source: Node, target: Node) -> void:
	for c in connections:
		if (c.source == source and c.target == target):
			c.line.queue_free()
			connections.erase(c)
			return

func clear_connections(node: Node) -> void:
	var to_remove := []
	for c in connections:
		if c.source == node or c.target == node:
			c.line.queue_free()
			to_remove.append(c)
	for c in to_remove:
		connections.erase(c)

# 查询某节点的输出连接
func get_connections_from(source: Node) -> Array:
	var output = []
	for c in connections:
		if c.source == source:
			output.append(c)
		
	return output


# 查询某节点的输入连接
func get_connections_to(target: Node) -> Array:
	var output = []
	for c in connections:
		if c.target == target:
			output.append(c)
		
	return output

func get_connection(from: Node, to: Node) -> Connection:
	for c: Connection in connections:
		if c.target == to and c.source == from:
			return c
			
	return null
	
# 每帧刷新连线位置
func _process(delta: float) -> void:
	for c in connections:
		if not (is_instance_valid(c.source) and is_instance_valid(c.target)):
			continue
		c.line.points = [
			c.source.global_position + Vector2(8, 8),
			c.target.global_position + Vector2(8, 8)
		]
