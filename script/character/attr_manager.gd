class_name AttrManager

class Attr:
	var baseValue: int
	var extraPercValue: float
	var extraValue: int
	
	func _init(b):
		self.baseValue = b
		self.extraPercValue = 0
		self.extraValue = 0
		
	func final_value():
		return baseValue * (1 + extraPercValue) + extraValue
		
	func modify_extra_value(v):
		match typeof(v):
			TYPE_INT: self.extraValue += v
			TYPE_FLOAT: self.extraPercValue += v
			
	func set_base_value(v):
		self.baseValue = v
		
	func extra_value():
		return round(baseValue * extraPercValue + extraValue)

var maxHP: Attr = Attr.new(100)
var maxMP: Attr = Attr.new(2500)
var speed: Attr = Attr.new(400)
var spellPower: Attr = Attr.new(10)
var inspiration: Attr = Attr.new(1000)

var critRate: float = 0.05
var critDamage: float = 1.5

var damageBonus := {
	"Fire": 0,
	"Frost": 0,
	"Blunt": 0,
	"Piercing": 0,
	"Poison": 0,
	"Force": 0,
	"Lightning": 0,
	"Psychic": 0,
	"Slash": 0,
}

var HP: int
var MP: int

func _init(d: Dictionary= {}):
	for key in d:
		match key:
			"maxHP": self.maxHP = Attr.new(d[key])
			"maxMP": self.maxMP = Attr.new(d[key])
			"speed": self.speed = Attr.new(d[key])
			"spellPower": self.spellPower = Attr.new(d[key])
			"inspiration": self.inspiration = Attr.new(d[key])
			
	self.HP = self.maxHP.final_value()
	self.MP = self.maxMP.final_value()

func set_state_value(sn: String, v: int):
	match sn:
		"HP": self.HP = clamp(self.HP + v, 0, self.maxHP.final_value())
		"MP": self.MP = clamp(self.MP + v, 0, self.maxMP.final_value())
		
func get_attr_dic(d: Array) -> Dictionary:
	var result = damageBonus.duplicate(true)
	var value
	for key: String in d:
		value = get(key)
		if typeof(value) == TYPE_FLOAT:
			result[key] = value
		elif is_instance_of(value, Attr):
			result[key] = value.final_value()
	return result
