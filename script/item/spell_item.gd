class_name SpellItem extends InteractableItem

var spell: GDScript

func set_spell_type(s: GDScript):
	spell = s

func activate(sub: BaseCharacter):
	sub.spellManager.add_spell(spell)
	print(sub)
	delete()

func delete():
	pass
