extends Node

@onready var spellEditorScene = preload("res://scene/UI/spells/spell_editor.tscn")

var isBoardOpen: bool = false
var board

func _ready():
	var enemy = preload("res://scene/enemy/duang_duang_worm.tscn").instantiate()
	add_child(enemy)
	enemy.global_position = Vector2(1000, 1100)
	enemy.set_target($BaseCharacter)
	print($BaseCharacter)
	
func _input(event):
	if Input.is_action_just_pressed("EditSpell"):
		if isBoardOpen:
			board.close_board()
		else:
			var spellEditor = spellEditorScene.instantiate()
			add_child(spellEditor)
			board = spellEditor
		
		isBoardOpen = not isBoardOpen
