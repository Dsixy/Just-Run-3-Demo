extends Control

var blockScene = preload("res://scene/UI/relation_map/block.tscn")
var blocks: Array = []
var chosenNode: Node
var connectionManager = ConnectionManager.new()

func _ready():
	add_child(connectionManager)
	init(0)
	
func init(player):
	var block = blockScene.instantiate()
	block.text = "火球咒语"
	block.spellClass = FireballSpell
	block.inputParams = 0
	add_child(block)
	block.connect("be_chosen", _on_block_be_chosen)
	
	block = blockScene.instantiate()
	block.text = "冰球咒语"
	block.spellClass = IceballSpell
	block.inputParams = 0
	add_child(block)
	block.connect("be_chosen", _on_block_be_chosen)
	block = blockScene.instantiate()
	block.text = "冰球咒语"
	block.spellClass = IceballSpell
	block.inputParams = 0
	add_child(block)
	block.connect("be_chosen", _on_block_be_chosen)
	
	block = blockScene.instantiate()
	block.text = "冰球咒语"
	block.spellClass = IceballSpell
	block.inputParams = 0
	add_child(block)
	block.connect("be_chosen", _on_block_be_chosen)
	
	block = blockScene.instantiate()
	block.text = "线性轨迹"
	block.spellClass = LinearTrajSpell
	block.inputParams = 1
	add_child(block)
	block.connect("be_chosen", _on_block_be_chosen)
	
	block = blockScene.instantiate()
	block.text = "环绕弹"
	block.spellClass = OrbitingWrapperSpell
	block.inputParams = 4
	add_child(block)
	block.connect("be_chosen", _on_block_be_chosen)
	
	block = blockScene.instantiate()
	block.text = "蛇形轨迹"
	block.spellClass = SerpentineTrajSpell
	block.inputParams = 1
	add_child(block)
	block.connect("be_chosen", _on_block_be_chosen)
	
	block = blockScene.instantiate()
	block.text = "双重打包"
	block.spellClass = TwinCastSpell
	block.inputParams = 2
	add_child(block)
	block.connect("be_chosen", _on_block_be_chosen)
	#var spell = FireballSpell.new()
	#var center_spell = FireballSpell.new()
	#var kspell = LinearTrajSpell.new([
		#OrbitingWrapperSpell.new([center_spell, IceballSpell.new(), IceballSpell.new(), IceballSpell.new()])
	#])
	#
	#var wrapper = ImpactWrapperSpell.new([spell, kspell])
	#var traj_spell = OrbitingTrajSpell.new([wrapper])
	#generate_board(traj_spell)
	
	block = blockScene.instantiate()
	block.text = "最终咒语"
	block.inputParams = 1
	add_child(block)
	block.connect("be_chosen", _on_block_be_chosen)
	
	await block.be_chosen
	await get_tree().create_timer(0.5).timeout
	var spellTree = SpellTree.new()
	await spellTree.build_tree_from_relation_set(block, connectionManager)
	GameInfo.spellTree = spellTree
	get_tree().change_scene_to_file("res://scene/game_scene_test.tscn")

func compile(root):
	var node = SpellTree.new()
	
	
func generate_board(spell: Spell):
	var block = blockScene.instantiate()
	block.text = spell.spellName
	block.inputParams = len(spell.inputParams)
	add_child(block)
	block.connect("be_chosen", _on_block_be_chosen)
	
	for s in spell.inputParams:
		generate_board(s) 
	
func connect_node(sourceNode: Node, targetNode: Node):
	connectionManager.add_connection(sourceNode, targetNode)

func _on_block_be_chosen(node):
	if chosenNode and chosenNode != node:
		chosenNode.dechoose()
		node.dechoose()
		if chosenNode.get_parent() != node.get_parent() and chosenNode.type != node.type:
			var source
			var target
			
			if chosenNode.type:
				source = chosenNode
				target = node
			else:
				source = node
				target = chosenNode
			if connectionManager.get_connection(source, target):
				connectionManager.remove_connection(source, target)
			elif connectionManager.get_connections_from(source) == [] and connectionManager.get_connections_to(target) == []:
				connect_node(source, target)
		chosenNode = null
		
	else:
		chosenNode = node
