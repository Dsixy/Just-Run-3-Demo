class_name IceballSpell extends ManifestSpell

var iceballScene = preload("res://scene/item/projectile/iceball.tscn")

var projectile: Node2D

func _init(spells: Array):
	projectile = iceballScene.instantiate()
	spellName = "冰球魔法"
	
func apply(params: Dictionary):
	projectile.params = params
	params["bulletNode"].add_child(projectile)
