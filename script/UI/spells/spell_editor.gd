extends UIBoard

class BoardIDManager:
	var ID2Board := {}
	func set_id_for_board(board: GraphNode):
		var id = 0
		while str(id) in ID2Board:
			id += 1
		self.ID2Board[str(id)] = board
		board.name = str(id)
		
	func remove_board(board: GraphNode):
		var id = board.name
		self.ID2Board.erase(id)
		
@onready var spellButtonScene = preload("res://scene/UI/spells/spell_button.tscn")
@onready var boardScene = preload("res://scene/UI/spells/spell_board.tscn")
@onready var buttonContainer = $HBoxContainer
@onready var editor = $GraphEdit

var player: BaseCharacter
var spellManager: SpellManager
var buttons := {}
var boardIDManager:= BoardIDManager.new()

func _init():
	self.boardName = "spell_edit_board"
	
func set_player(p: BaseCharacter):
	player = p
	set_spell_manager(player.spellManager)
	
func set_spell_manager(sm: SpellManager):
	self.spellManager = sm

	for spellClass in spellManager.spells:
		var button = spellButtonScene.instantiate()
		buttonContainer.add_child(button)
		button.set_properties(spellClass, spellManager.spells[spellClass])
		button.pressS.connect(_on_spell_button_pressed)
		buttons[spellClass] = button
		
	if self.spellManager.graphDicData != {}:
		self.load_graph(self.spellManager.graphDicData)

func update_all_board():
	for child in editor.get_children():
		if child.get("spellClass"):
			child.compile()
			child.update_info()

func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	connect_board(from_node, from_port, to_node, to_port)

func connect_board(from_node, from_port, to_node, to_port):
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
	if buttons[spell_class].restNum > 0:
		var board = boardScene.instantiate()
		editor.add_child(board)
		
		boardIDManager.set_id_for_board(board)
		board.init_by_spell_class(spell_class)
		buttons[spell_class].restNum -= 1

func _on_graph_edit_delete_nodes_request(nodes):
	for nodeName in nodes:
		for conn in editor.get_connection_list():
			if conn.from_node == nodeName or conn.to_node == nodeName:
				self.disconnect_node(conn.from_node, conn.from_port, conn.to_node, conn.to_port)
				
		var node = editor.get_node(NodePath(nodeName))
		var spell_class = node.spellClass
		
		buttons[spell_class].restNum += 1
		boardIDManager.remove_board(node)
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

	spellManager.graphDicData = save_graph()
	
	if targetBoard:
		var chosenSpellIdx = spellManager.currentSpellIdx
		player.spellManager.compiledSpells[chosenSpellIdx] = targetBoard.treeNode
		return targetBoard.treeNode
	else:
		return null

func save_graph() -> Dictionary:
	var data := {
		"nodes": [],
		"connections": []
	}

	for node in $GraphEdit.get_children():
		if node is GraphNode:
			data["nodes"].append({
				"name": node.name,
				"type": node.get_class(), 
				"position": node.position_offset,
				"data": node.export_data()
			})

	var conns = $GraphEdit.get_connection_list()
	for c in conns:
		data["connections"].append([
			c.from_node,
			c.from_port,
			c.to_node,
			c.to_port
		])

	return data

func load_graph(data: Dictionary):
	for child in $GraphEdit.get_children():
		if child is GraphNode:
			child.queue_free()

	await get_tree().process_frame

	for n in data["nodes"]:
		var node_scene = load("res://scene/UI/spells/spell_board.tscn")
		var node: GraphNode = node_scene.instantiate()
		node.name = n["name"]
		node.position_offset = n["position"]
		$GraphEdit.add_child(node)
		node.import_data(n["data"])

	for c in data["connections"]:
		connect_board(c[0], c[1], c[2], c[3])
	update_all_board()
