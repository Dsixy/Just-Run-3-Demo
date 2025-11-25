extends NPC

func _ready():
	super._ready()
	self.dialogManager.set_current_dialog_name("dialog_0")

func on_dialog_over(current_dialog_name: String):
	match current_dialog_name:
		"dialog_0": self.dialogManager.set_current_dialog_name("dialog_1")
