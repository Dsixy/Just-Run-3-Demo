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
var currentState: State
@onready var buffManager = $BuffManager

var damageScaleManager = DamageScaleManager.new()

var targetGroup := "player"
var target: Node2D
var physicScale: float = 1
var processScale: float = 1

signal deathS(node: BaseEnemy)

func _init():
	self.attr = EnemyAttr.new()
	self.state = EnemyState.new(self.attr)
	
func _physics_process(delta):
	if currentState and physicScale > 0.1:
		currentState.physics_process(delta * physicScale)
		
func _process(delta):
	if currentState and physicScale > 0.1:
		currentState.process(delta * processScale)
		
func transite_to_state(s: State):
	if self.currentState:
		self.currentState.exit()
	self.currentState = s
	self.currentState.transiteStateS.connect(transite_to_state)
	self.currentState.enter()
	
func activate():
	pass

func take_damage(damage: Damage):
	damage = self.buffManager.process_damage(damage)
	damage = self.damageScaleManager.process_damage(damage)
	var final_damage_amount = damage.finalDamage * self.attr.damageMultiplier[damage.type]
	FightInfoManager.show_damage_label(damage, global_position + Vector2.UP * 50)
	self.state.HP -= final_damage_amount
	
	if self.state.HP <= 0:
		self.death()
		
func death():
	deathS.emit(self)
	queue_free()
	
func add_buff(buff: BaseBuff):
	self.buffManager.add_buff(buff)
