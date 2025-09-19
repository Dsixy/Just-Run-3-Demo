class_name Damage

enum DamageType {Frost, Fire}
var baseAmount: int
var bonus: float
var isCrit: bool
var critRate: float
var critDamage: float
var type: DamageType
var finalDamage: int:
	get:
		return 0

func _init():
	pass

