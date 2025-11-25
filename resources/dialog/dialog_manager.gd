class_name DialogManager
extends Resource

var dialogue_data: Dictionary
var current_dialog_name: String
var current_id: int = -1

signal dialogOverS(currentName: String)

func _init(json_path: String = ""):
	if json_path != "":
		dialogue_data = load_dialogue(json_path)

func load_dialogue(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("DialogManager: Failed to open dialogue file at %s" % path)
		return {}
	
	var json_str := file.get_as_text()
	var result = JSON.parse_string(json_str)
	if result:
		current_id = 0
	
	return result

func set_current_dialog_name(dialog_name: String):
	if dialog_name in dialogue_data:
		current_dialog_name = dialog_name
		current_id = 0
	else:
		push_warning("%s not found in dialogue data!" % dialog_name)
		current_id = -1

func get_dialog() -> Dictionary:
	if current_id == -1:
		return {}
	
	var dialog := get_dialogue_by_id(current_id)
	if not dialog:
		current_id = -1
		return {}
	
	# ---- 普通顺序跳转 ----
	if dialog.has("next"):
		current_id = dialog["next"]
		return dialog
	
	# ---- 跨对话分支跳转 ----
	if dialog.has("next_dialog"):
		var next_dialog_name := ""
		
		for option in dialog["next_dialog"]:
			if not option.has("condition") or FightInfoManager.flagManager.has_flag(option["condition"]):
				next_dialog_name = option["dialog_name"]
				break 
		
		if next_dialog_name != "":
			set_current_dialog_name(next_dialog_name)
			dialogOverS.emit(next_dialog_name)
		else:
			# 没有任何可跳转条件，说明剧情结束
			dialogOverS.emit("dialog_end")
		
		return dialog
	
	# ---- 无 next / next_dialog：对话结束 ----
	current_id = -1
	dialogOverS.emit("dialog_end")
	return dialog


func get_dialogue_by_id(id: int) -> Dictionary:
	if not dialogue_data.has(current_dialog_name):
		push_warning("DialogManager: No current dialog name set.")
		return {}
	
	var dialogs = dialogue_data[current_dialog_name]
	if id >= 0 and id < dialogs.size():
		return dialogs[id]
	
	push_warning("DialogManager: Invalid dialog id %d" % id)
	return {}
