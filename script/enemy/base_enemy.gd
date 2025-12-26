class_name BaseEnemy extends CharacterBody2D

@export var enemyName: String
var attrManager: AttrManager

var currentState: State
@onready var buffManager = $BuffManager

var damageScaleManager = DamageScaleManager.new()

var targetGroup := "player"
var target: Node2D
var physicScale: float = 1
var processScale: float = 1

var isBoss: bool = false

signal deathS(node: BaseEnemy)
signal HPChangeS

func _init():
	self.attrManager = AttrManager.new({
		"maxHP": 200,
		"speed": 250
	})
	
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
	var final_damage_amount = damage.finalDamage
	FightInfoManager.show_damage_label(damage, global_position + Vector2.UP * 50)
	self.attrManager.set_state_value("HP", -final_damage_amount)
	HPChangeS.emit()
	
	if self.attrManager.HP <= 0:
		self.death()
		
func heal(v: int):
	self.attrManager.set_state_value("HP", v)
	FightInfoManager.show_value_label(v, global_position + Vector2.UP * 50, Color8(100, 255, 100))
	HPChangeS.emit()
	
func death():
	deathS.emit(self)
	queue_free()
	
func add_buff(buff: BaseBuff):
	self.buffManager.add_buff(buff)
