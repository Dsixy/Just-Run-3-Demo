class_name SpellItem extends InteractableItem

@onready var sprite = $Graphic/Sprite2D
var spell: GDScript

func _ready():
	sprite.texture = spell.icon
	
func set_spell_type(s: GDScript):
	spell = s

func activate(sub: BaseCharacter):
	sub.spellManager.add_spell(spell)
	delete()

func delete():
	queue_free()
