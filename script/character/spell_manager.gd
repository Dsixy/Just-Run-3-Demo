class_name SpellManager

var spells := {}
var compiledSpells := []

var currentSpellIdx: int = 0

func _init():
	self.spells = {
		FireballSpell: 3,
		LinearTrajSpell: 1
	}
	
func add_spell(spell: GDScript):
	if spell in spells:
		spells[spell] += 1
	else:
		spells[spell] = 1
