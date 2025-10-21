extends Control

@onready var HPBar = $StateBoard/MarginContainer/VBoxContainer/HPBar
@onready var HPBarLabel = $StateBoard/MarginContainer/VBoxContainer/HPBar/Label
@onready var MPBar = $StateBoard/MarginContainer/VBoxContainer/MPBar
@onready var MPBarLabel = $StateBoard/MarginContainer/VBoxContainer/MPBar/Label

var stateOwner: BaseCharacter

func set_state_owner(p: BaseCharacter):
	self.stateOwner = p
	self.stateOwner.stateChangeS.connect(update_info)
	update_info()
	
func update_info():
	HPBar.max_value = stateOwner.attr.maxHP
	HPBar.value = stateOwner.state.HP
	HPBarLabel.text = "{0}/{1}".format([stateOwner.state.HP, stateOwner.attr.maxHP])
	MPBar.max_value = stateOwner.attr.maxMP
	MPBar.value = stateOwner.state.MP
	MPBarLabel.text = "{0}/{1}".format([stateOwner.state.MP, stateOwner.attr.maxMP])
