extends Node

@onready var spellEditorScene = preload("res://scene/UI/spells/spell_editor.tscn")
@onready var roomManager = $RoomManager
@onready var player = $BaseCharacter
@onready var UILayer = $UILayer
var isBoardOpen: bool = false
var board

func _ready():
	$UILayer/PlayerStatUI.set_state_owner(player)
	roomManager.player = player
	roomManager.test()
	
func _input(event):
	if Input.is_action_just_pressed("EditSpell"):
		if isBoardOpen:
			var spell = board.close_board()
			player.set_spell(spell)
			board.queue_free()
		else:
			var spellEditor = spellEditorScene.instantiate()
			UILayer.add_child(spellEditor)
			spellEditor.set_spell_manager(player.spellManager)
			board = spellEditor
		
		isBoardOpen = not isBoardOpen
