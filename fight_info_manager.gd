extends Control

const DamageLabelScene = preload("res://scene/UI/fight/damage_label.tscn")

func show_damage_label(damage: Damage, pos:Vector2):
	var label = DamageLabelScene.instantiate()
	add_child(label)
	label.run(damage, pos)
