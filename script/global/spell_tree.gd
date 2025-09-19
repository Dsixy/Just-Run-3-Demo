class_name SpellTree

class TreeNode:
	var spellClass
	var input: Array[TreeNode]
	var output: TreeNode
	
	func _init(className=null):
		spellClass = className
		input = []
	
var rootNode: TreeNode

func compile(root):
	pass

func build_tree_from_relation_set(rootBlock, relationSet: ConnectionManager):
	rootNode = self.build_from_relation_set(rootBlock, relationSet).input[0]
	
func build_from_relation_set(rootBlock, relationSet: ConnectionManager) -> TreeNode:
	var node = TreeNode.new(rootBlock.spellClass)
	
	var inputs = rootBlock.inputNodes
	for input in inputs:
		var from = relationSet.get_connections_from(input)
		if from != []:
			var block = from[0].target.get_parent()
			node.input.append(build_from_relation_set(block, relationSet))
		
	return node

func create_spell():
	return create_spell_from_node(rootNode)
	
func create_spell_from_node(node: TreeNode):
	var inputSpells = []
	for input_ in node.input:
		inputSpells.append(create_spell_from_node(input_))

	var spell = node.spellClass.new(inputSpells)
	print(spell.spellName)
	
	return spell
	
