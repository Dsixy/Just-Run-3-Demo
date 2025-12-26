extends Node

@onready var spellEditorScene = preload("res://scene/UI/spells/spell_editor.tscn")
@onready var attrBoardScene = preload("res://scene/UI/attr_board.tscn")
@onready var roomManagerScene = preload("res://scene/room/room_manager.tscn")
@onready var player = $BaseCharacter
@onready var UILayer = $UILayer
@onready var itemNode = $ItemNode

@onready var roomManager = $RoomManager
var isBoardOpen: bool = false
var board

func _ready():
	$UILayer/PlayerStatUI.set_state_owner(player)
	UILayer.set_player(player)
	GameInfo.mainscene = self
	set_room_manager()
	
func set_room_manager():
	if roomManager:
		roomManager.queue_free()
	roomManager = roomManagerScene.instantiate()

	roomManager.player = player
	var info = GameInfo.roomSetManager.next()
	if info:
		roomManager.set_info(info)
		add_child(roomManager)
		roomManager.set_room_player()
	else:
		print("You win!")
	
func next_layer():
	roomManager.queue_free()
	set_room_manager()
	player.global_position = Vector2(0, 0)
	
func _input(event):
	if Input.is_action_just_pressed("EditSpell"):
		var spellEditor = spellEditorScene.instantiate()
		var flag = UILayer.add_UI_board(spellEditor)
	
		if flag:
			get_tree().paused = true
	elif Input.is_action_just_pressed("OpenAttrBoard"):
		var attrBoard = attrBoardScene.instantiate()
		var flag = UILayer.add_UI_board(attrBoard)
	
		if flag:
			get_tree().paused = true

func _on_ui_layer_ui_board_closed_s():
	if UILayer.currentUIBoard == null:
		get_tree().paused = false
