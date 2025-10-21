class_name BaseCharacter extends CharacterBody2D

class CharacterAttr:
	var maxHP: int = 100
	var speed: int = 250
	var critRate: float = 0.05
	var spellPower: int = 10
	var maxMP: int = 250
	var inspiration: float = 4.0
	var castSpeedModifier: float = 0.0
	var prosperity: float = 0.0
	var magicPenetration: float = 0.0
	var critDamage: float = 2.0
	
class CharacterState:
	var HP: float
	var MP: float
	
	func _init(attr: CharacterAttr):
		self.HP = attr.maxHP
		self.MP = attr.maxMP

var attr: CharacterAttr
var state: CharacterState
var direction: Vector2

var spells = []
var canApplySpell: bool = true
@onready var coolDownTimer = $Node/CastTimer
signal stateChangeS

func _init():
	self.attr = CharacterAttr.new()
	self.state = CharacterState.new(self.attr)
	
func _input(event):
	direction = Vector2.ZERO
	if Input.is_action_pressed("MoveLeft"):
		direction.x = -1
	if Input.is_action_pressed("MoveRight"):
		direction.x = 1
	if Input.is_action_pressed("MoveUp"):
		direction.y = -1
	if Input.is_action_pressed("MoveDown"):
		direction.y = 1
		
	direction = direction.normalized()
	
	if Input.is_action_pressed("Apply") and self.canApplySpell:
		apply_spell(GameInfo.spells[0])
		pass
	
func apply_spell(spellTree: SpellTreeNode):
	if spellTree == null:
		return
		
	var spell = spellTree.cast()
	var arr = spell.compute_cost_and_time()
	var cost = arr[0]
	var time = arr[1]
	
	if cost > self.state.MP:
		return
		
	self.state.MP -= cost
	var dict = {
		"mainscene": get_parent(),
		"position": global_position,
		"target_position": get_global_mouse_position(),
		"player_attr_info": attr,
		"player_state_info": state
	}
	spell.apply(dict)
	self.canApplySpell = false
	self.coolDownTimer.start(time)
	
	emit_signal("stateChangeS")
	
func _physics_process(delta):
	velocity = direction * attr.speed
	move_and_slide()
	
func take_damage(damage: Damage):
	var final_damage_amount = damage.finalDamage
	FightInfoManager.show_damage_label(damage, global_position + Vector2.UP * 50)
	self.state.HP = max(self.state.HP - final_damage_amount, 0)
	emit_signal("stateChangeS")
	
	if self.state.HP <= 0:
		self.death()

func death():
	set_process(false)
	set_physics_process(false)
	print("You Loss")

func _on_mana_timer_timeout():
	self.state.MP = min(self.attr.maxMP, self.state.MP + self.attr.inspiration)
	emit_signal("stateChangeS")


func _on_cast_timer_timeout():
	self.canApplySpell = true
