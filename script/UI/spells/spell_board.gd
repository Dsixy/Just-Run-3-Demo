extends GraphNode

@onready var drawerScene = preload("res://scene/UI/spells/drawer.tscn")
@onready var slideScene = preload("res://scene/UI/spells/slider.tscn")
@onready var manaLabel = $HBoxContainer/VBoxContainer/ManaLabel
@onready var castTimeLabel = $HBoxContainer/VBoxContainer/TimeLabel

var spellClass: GDScript
var treeNode: SpellTreeNode
var params := {}
var inputFields := {}

func override(spell_class):
	var idx: int = 1
	self.spellClass = spell_class
	self.treeNode = SpellTreeNode.new(self.spellClass)

	for key in self.spellClass.boardParams:
		var subUI: Control
		var boardParam = self.spellClass.boardParams[key]
		match typeof(boardParam[1]):
			TYPE_CALLABLE:
				subUI = drawerScene.instantiate()
				add_child(subUI)
				# name, filter
				subUI.set_properties(key, boardParam[0], boardParam[1])
				
				set_slot_enabled_left(idx, true)
				inputFields[idx] = subUI
				params[key] = null
			TYPE_INT:
				subUI = slideScene.instantiate()
				add_child(subUI)
				# name, min, max, step
				subUI.set_properties(key, boardParam[0], boardParam[1], boardParam[2], boardParam[3])
				params[key] = boardParam[1]
			TYPE_FLOAT:
				subUI = slideScene.instantiate()
				add_child(subUI)
				# name, min, max, step
				subUI.set_properties(key, boardParam[0], boardParam[1], boardParam[2], boardParam[3])
				params[key] = boardParam[1]
			TYPE_STRING:
				print("string")
			_:
				print("unknown type")
		subUI.changeS.connect(on_sub_value_changed)
		
		idx += 1
		
	self.compile()
	self.update_info()
	
	self.title = self.spellClass.spellName + "【"+ "】【".join(self.spellClass.keys) + "】"
	
func on_sub_value_changed(n: String, v):
	if n in params:
		params[n] = v

func compile():	
	var subSpells = []
	for slot in self.inputFields:
		var value = self.inputFields[slot].value
		if value:
			subSpells.append(value.compile())
		else:
			subSpells.append(null)
			
	self.treeNode.subNodes = subSpells
	self.treeNode.extraParams = self.params
	
	return treeNode
	
func update_info():
	var spell = self.treeNode.cast()
	var arr = spell.compute_cost_and_time()
	
	self.manaLabel.text = "Mana Cost:\n{0}".format([arr[0]])
	self.castTimeLabel.text = "Cast Time:\n{0}s".format([arr[1]])
