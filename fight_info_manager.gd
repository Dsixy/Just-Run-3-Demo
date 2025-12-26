extends Control

const DamageLabelScene = preload("res://scene/UI/fight/damage_label.tscn")
var flagManager: FlagManager

func _ready():
	self.flagManager = FlagManager.new()

func show_damage_label(damage: Damage, pos:Vector2):
	var label = DamageLabelScene.instantiate()
	add_child(label)
	label.run(damage, pos)
	
func show_value_label(value: int, pos:Vector2, c: Color):
	var label = DamageLabelScene.instantiate()
	add_child(label)
	var damage = Damage.new(value, 0, 0, 1, "Poison")
	label.run(damage, pos)
