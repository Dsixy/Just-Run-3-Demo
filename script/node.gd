extends Node

@onready var spellEditorScene = preload("res://scene/UI/spells/spell_editor.tscn")
@onready var roomManager = $RoomManager
@onready var player = $BaseCharacter
@onready var UILayer = $UILayer
@onready var itemNode = $ItemNode
var isBoardOpen: bool = false
var board

func _ready():
	$UILayer/PlayerStatUI.set_state_owner(player)
	UILayer.set_player(player)
	roomManager.player = player
	roomManager.test()
	GameInfo.mainscene = self
	
func _input(event):
	if Input.is_action_just_pressed("EditSpell"):
		var spellEditor = spellEditorScene.instantiate()
		var flag = UILayer.add_UI_board(spellEditor)
	
		if flag:
			get_tree().paused = true

func _on_ui_layer_ui_board_closed_s():
	if UILayer.currentUIBoard == null:
		get_tree().paused = false
