class_name SpellTreeNode

var spellClass
var extraParams: Dictionary
var subNodes: Array

func _init(spell_class, extra_params: Dictionary = {}, sub_nodes: Array = []):
	self.spellClass = spell_class
	self.extraParams = extra_params
	self.subNodes = sub_nodes
	
func cast() -> BaseSpell:
	var subSpells = []
	for subNode: SpellTreeNode in subNodes:
		if subNode:
			subSpells.append(subNode.cast())
		else:
			subSpells.append(null)
	var spell = spellClass.new(subSpells, self)
	
	return spell
	
func copy():
	var subs = []
	for subNode in self.subNodes:
		if subNode:
			subs.append(subNode.copy())
		else:
			subs.append(null)
	return SpellTreeNode.new(self.spellClass, self.extraParams, subs)
	
func show():
	print('(', spellClass.spellName)
	print(self.extraParams)
	for sub in subNodes:
		if sub:
			sub.show()
	print(')')
