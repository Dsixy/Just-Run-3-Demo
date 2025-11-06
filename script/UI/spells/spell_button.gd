extends Control

@onready var button = $Button
@onready var numLabel = $Label
var spellClass: GDScript
var _restNum: int
var restNum: int:
	set(v):
		_restNum = v
		numLabel.text = "{0}".format([v])
	get:
		return _restNum

signal pressS(spell_class: GDScript)

func set_properties(spell_class, rest_num: int=0):
	self.spellClass = spell_class
	self.restNum = rest_num
	button.text = spell_class.spellName

func _on_button_pressed():
	pressS.emit(self.spellClass)
