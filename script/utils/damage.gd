class_name Damage

var baseAmount: int
var bonus: float
var isCrit: bool
var critRate: float
var critDamage: float
var type: String
var finalDamage: int:
	get:
		if isCrit:
			return baseAmount * critDamage * (bonus + 1)
		else:
			return baseAmount * (bonus + 1)

## @param base_amount int
func _init(base_amount: int, bonus_: float = 0, crit_rate: float = 0, \
	crit_damage: float = 1, type_: String = "Fire"):
	baseAmount = base_amount
	bonus = bonus_
	critRate = crit_rate
	critDamage = crit_damage
	type = type_
	
	isCrit = randf() < critRate

func copy():
	return Damage.new(baseAmount, bonus, critRate, critDamage, type)
