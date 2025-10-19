extends Control

@onready var spellButtonScene = preload("res://scene/UI/spells/spell_button.tscn")
@onready var buttonContainer = $HBoxContainer
@onready var editor = $GraphEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	for spellClass in [FireballSpell, LinearTrajSpell]:
		var button = spellButtonScene.instantiate()
		buttonContainer.add_child(button)
		button.set_properties(spellClass)
		button.pressS.connect(_on_spell_button_pressed)

func update_all_board():
	for child in editor.get_children():
		if child.get("spellClass"):
			child.compile()
			child.update_info()

func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	var fromNode = editor.get_node(NodePath(from_node))
	var toNode = editor.get_node(NodePath(to_node))
	var toSlot = toNode.get_input_port_slot(to_port)
	
	if toNode.inputFields[toSlot].value:
		return
	if not toNode.inputFields[toSlot].filter.call(fromNode.spellClass):
		return
		
	toNode.inputFields[toSlot].value = fromNode
	editor.connect_node(from_node,from_port, to_node, to_port)
	
	update_all_board()


func _on_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	self.disconnect_node(from_node, from_port, to_node, to_port)
	
func _on_spell_button_pressed(spell_class):
	var board = preload("res://scene/UI/spells/spell_board.tscn").instantiate()
	editor.add_child(board)
	board.override(spell_class)


func _on_graph_edit_delete_nodes_request(nodes):
	for nodeName in nodes:
		for conn in editor.get_connection_list():
			if conn.from_node == nodeName or conn.to_node == nodeName:
				self.disconnect_node(conn.from_node, conn.from_port, conn.to_node, conn.to_port)
				
		var node = editor.get_node(NodePath(nodeName))
		node.queue_free()
	
func disconnect_node(from_node, from_port, to_node, to_port):
	var toNode = editor.get_node(NodePath(to_node))
	var toSlot = toNode.get_input_port_slot(to_port)
	toNode.inputFields[toSlot].value = null
	editor.disconnect_node(from_node, from_port, to_node, to_port)
	update_all_board()

func close_board():
	var targetBoard
	
	update_all_board()
	for board in editor.get_children():
		if board is GraphNode and board.selected:
			targetBoard = board
			break
			
	GameInfo.spells[0] = targetBoard.treeNode
	GameInfo.spells[0].show()
	queue_free()
	
