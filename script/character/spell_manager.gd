class_name SpellManager

var spells := {}
var compiledSpells := []
var maxSpellNum: int = 2
var currentSpellIdx: int = 0

var graphDicData: Dictionary

func _init():
	self.spells = {
		StoneConeSpell: 1,
		LinearTrajSpell: 5,
		#SnowballSpell: 2,
		FireballSpell: 1,
		#PierceProjModSpell: 1,
		#BounceTrajSpell: 1,
		#ExplodeFieldSpell: 1,
		#OrbitTrajSpell: 5,
		HomingTrajSpell: 1,
		QuickCastSpell: 1,
		#AdvancedQuickCastSpell: 1,
		BarrageSpell: 1,
		#DualCastSpell: 3,
		DoubleCastSpell: 1
	}
	
	for i in range(maxSpellNum):
		compiledSpells.append(null)
	
func add_spell(spell: GDScript):
	if spell in spells:
		spells[spell] += 1
	else:
		spells[spell] = 1

func allocate_spell():
	var spell: SpellTreeNode = compiledSpells[currentSpellIdx]
	if spell:
		return spell.cast()
	else:
		return null

func roll_current_spell_idx(up: bool):
	if up:
		currentSpellIdx = clamp(currentSpellIdx + 1, 0, maxSpellNum - 1)
	else:
		currentSpellIdx = clamp(currentSpellIdx - 1, 0, maxSpellNum - 1)

func set_current_spell_idx(idx: int):
	if idx < maxSpellNum - 1 and idx >= 0:
		currentSpellIdx = idx
