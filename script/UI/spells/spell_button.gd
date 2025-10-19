extends Control

@onready var button = $Button
var spellClass: GDScript

signal pressS(spell_class: GDScript)

func set_properties(spell_class):
	self.spellClass = spell_class
	button.text = spell_class.spellName

func _on_button_pressed():
	pressS.emit(self.spellClass)
