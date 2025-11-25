extends Control

@onready var HPBar = $StateBoard/MarginContainer/VBoxContainer/HPBar
@onready var HPBarLabel = $StateBoard/MarginContainer/VBoxContainer/HPBar/Label
@onready var MPBar = $StateBoard/MarginContainer/VBoxContainer/MPBar
@onready var MPBarLabel = $StateBoard/MarginContainer/VBoxContainer/MPBar/Label
@onready var spellIconContainer = $StateBoard/MarginContainer/VBoxContainer/HBoxContainer

@onready var test = $StateBoard/MarginContainer/VBoxContainer/HBoxContainer/GPUParticles2D
var stateOwner: BaseCharacter
var spellIconList: Array

func set_state_owner(p: BaseCharacter):
	self.stateOwner = p
	self.stateOwner.stateChangeS.connect(update_info)
	
	#for i in range(stateOwner.spellManager.maxSpellNum):
		#var spellIcon = TextureRect.new()
	spellIconList = spellIconContainer.get_children()
		
	update_info()
	
func update_info():
	HPBar.max_value = stateOwner.attr.maxHP
	HPBar.value = stateOwner.state.HP
	HPBarLabel.text = "{0}/{1}".format([stateOwner.state.HP, stateOwner.attr.maxHP])
	MPBar.max_value = stateOwner.attr.maxMP
	MPBar.value = stateOwner.state.MP
	MPBarLabel.text = "{0}/{1}".format([stateOwner.state.MP, stateOwner.attr.maxMP])
	
	for icon in self.spellIconList:
		icon.modulate = Color8(100, 100, 100, 0)
	var chosenSpellIdx = self.stateOwner.spellManager.currentSpellIdx
	spellIconList[chosenSpellIdx].modulate = Color8(100, 100, 100, 255)
