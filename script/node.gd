extends Node

@onready var spellEditorScene = preload("res://scene/UI/spells/spell_editor.tscn")

var isBoardOpen: bool = false
var board

func _input(event):
	if Input.is_action_just_pressed("EditSpell"):
		if isBoardOpen:
			board.close_board()
		else:
			var spellEditor = spellEditorScene.instantiate()
			add_child(spellEditor)
			board = spellEditor
		
		isBoardOpen = not isBoardOpen
