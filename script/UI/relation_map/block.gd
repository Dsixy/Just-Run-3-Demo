extends Control

const dragNodeScene = preload("res://scene/UI/relation_map/drop_node.tscn")
var inputParams: int = 3
var outputParams: int = 1
var inputNodes: Array = []

# drag
var dragging := false
var drag_offset := Vector2.ZERO

# info
var spellClass
var text: String:
	get:
		return $MarginContainer/HBoxContainer/Label.text
	set(value):
		$MarginContainer/HBoxContainer/Label.text = value
		
signal be_chosen(node: Node)

func _ready():
	var y = self.size.y / self.inputParams
	for i in range(self.inputParams):
		var dragNode = dragNodeScene.instantiate()
		dragNode.type = true
		add_child(dragNode)
		
		dragNode.id = i
		dragNode.position = Vector2(0, y * (i + 0.5)) - Vector2(16, 16)
		
		dragNode.connect("be_chosen", manage_node)
		inputNodes.append(dragNode)
		
	y = self.size.y / self.outputParams
	for i in range(self.outputParams):
		var dragNode = dragNodeScene.instantiate()
		dragNode.type = false
		add_child(dragNode)
		
		dragNode.position = Vector2(self.size.x, y * (i + 0.5)) - Vector2(16, 16)
		dragNode.id = i + inputParams
		
		dragNode.connect("be_chosen", manage_node)

func manage_node(node: Node):
	emit_signal("be_chosen", node)
	
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_offset = event.position
			else:
				dragging = false

	elif event is InputEventMouseMotion and dragging:
		global_position += event.relative
