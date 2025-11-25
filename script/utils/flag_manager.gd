extends Node
class_name FlagManager

var flags: Dictionary = {}

func set_flag(name: String, value: bool = true):
	flags[name] = value

func get_flag(name: String) -> bool:
	return flags.get(name, false)

func has_flag(name: String) -> bool:
	return get_flag(name)
