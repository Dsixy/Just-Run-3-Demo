class_name BaseEnemy extends CharacterBody2D

class EnemyAttr:
	var damageMultiplier: Dictionary = {
		"Fire": 1.0,
		"Frost": 1.0,
		"Piercing": 1.0,
		"Blunt": 1.0,
		"Slashing": 1.0,
		"Force": 1.0,
		"Psychic": 1.0,
		"Poison": 1.0,
		"Lightning": 1.0
	}
	
	var speed: int = 200
	var maxHP: int = 100
	
class EnemyState:
	var HP: float = 0
	
	func _init(attr: EnemyAttr = null):
		if attr:
			HP = attr.maxHP
		else:
			HP = 150
	
var attr: EnemyAttr
var state: EnemyState

func _init():
	self.attr = EnemyAttr.new()
	self.state = EnemyState.new(self.attr)
	
func _physics_process(delta):
	move_and_slide()
