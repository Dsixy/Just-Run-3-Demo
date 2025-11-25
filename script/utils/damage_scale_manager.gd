class_name DamageScaleManager

# TODO 最好能整合到player stats里面去
var damageResis := {
	"Fire": 0,
	"Frost": 0,
	"Blunt": 0,
	"Piercing": 0,
	"Poison": 0,
	"Force": 0,
	"Lightning": 0,
	"Psychic": 0
}

var damageImmun := {
	"Fire": false,
	"Frost": false,
	"Blunt": false,
	"Piercing": false,
	"Poison": false,
	"Force": false,
	"Lightning": false,
	"Psychic": false
}

func set_damage_all_immu(i: bool):
	for damage_type in damageImmun:
		damageImmun[damage_type] = i
		
func set_damage_immu(damage_types: Array, i: bool):
	for damage_type in damage_types:
		damageImmun[damage_type] = i
	
func process_damage(damage: Damage):
	if damageImmun[damage.type]:
		damage.baseAmount = 0
		
		return damage
	damage.bonus *= (1 - damageResis[damage.type])
	
	return damage
