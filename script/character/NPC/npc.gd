class_name NPC extends Node2D

@export var id: int
@export var NPCName: String
@export var dialogResourcePath: String
var dialogManager: DialogManager

@onready var dialogLabel = $Label

func _ready():
	self.dialogManager = DialogManager.new(dialogResourcePath)
	self.dialogManager.dialogOverS.connect(on_dialog_over)
	self.dialogManager.set_current_dialog_name("dialog_0")
	
func hover():
	pass
	
func activate(target: BaseCharacter):
	var dialog = self.dialogManager.get_dialog()
	if dialog:
		dialogLabel.text = dialog["text"]
	else:
		dialogLabel.text = ""
	
func on_dialog_over(current_dialog_name: String):
	pass
