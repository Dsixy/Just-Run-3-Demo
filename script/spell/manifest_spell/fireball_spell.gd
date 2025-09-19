class_name FireballSpell extends ManifestSpell

var fireballScene = preload("res://scene/item/projectile/fireball.tscn")

var projectile: Node2D

func _init(spells: Array):
	projectile = fireballScene.instantiate()
	spellName = "火球魔法"
	
func apply(params: Dictionary):
	projectile.params = params
	params["bulletNode"].add_child(projectile)
