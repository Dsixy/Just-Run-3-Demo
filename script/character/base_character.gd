class_name BaseCharacter extends CharacterBody2D

class CharacterAttr:
	var maxHP: int = 100
	var speed: int = 450
	var critRate: float = 0.05
	var spellPower: int = 10
	var maxMP: int = 250
	var inspiration: float = 100.0
	var prosperity: float = 0.0
	var magicPenetration: float = 0.0
	var critDamage: float = 2.0
	
	func modify_attr(sn: String, v: int):
		var value = self.get(sn)
		if value:
			self.set(sn, value + v)
			
	func set_attr(sn: String, v: int):
		var value = self.get(sn)
		if value:
			self.set(sn, v)
	
class CharacterState:
	var HP: float
	var MP: float
	var attr: CharacterAttr
	
	func _init(a: CharacterAttr):
		self.HP = a.maxHP
		self.MP = a.maxMP
		self.attr = a
		
	func modify_state(sn: String, v: int):
		match sn:
			"HP": self.HP = clamp(self.HP + v, 0, self.attr.maxHP)
			"MP": self.MP = clamp(self.MP + v, 0, self.attr.maxMP)
			_: push_error("no such state!")

var attr: CharacterAttr
var state: CharacterState
var direction: Vector2

var canApplySpell: bool = true
var spellManager := SpellManager.new()
@onready var coolDownTimer = $Node/CastTimer
@onready var buffManager = $BuffManager
signal stateChangeS
signal applySpellS

var couponManager:= CouponManager.new()
@onready var interactArea = $InteractArea

func _init():
	self.attr = CharacterAttr.new()
	self.state = CharacterState.new(self.attr)
	self.couponManager.couponChangeS.connect(func(): emit_signal("stateChangeS"))

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
	
	if Input.is_action_just_pressed("NextSpell"):
		self.spellManager.roll_current_spell_idx(false)
		emit_signal("stateChangeS")
	elif Input.is_action_just_pressed("PreviousSpell"):
		self.spellManager.roll_current_spell_idx(true)
		emit_signal("stateChangeS")
	
	if Input.is_action_pressed("Apply") and self.canApplySpell:
		apply_spell(self.spellManager.allocate_spell())
		
	if Input.is_action_just_pressed("Interact"):
		interact()
	
func apply_spell(spell: BaseSpell):
	if spell == null:
		return
		
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
		"player_state_info": state,
		"applier": self
	}
	spell.apply(dict)
	
	emit_signal("applySpellS")
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

func interact():
	var items = interactArea.get_overlapping_areas()
	for itemA in items:
		var item = itemA.get_parent()
		if is_instance_of(item, InteractableItem) or is_instance_of(item, NPC):
			item.activate(self)
	
func death():
	set_process(false)
	set_physics_process(false)
	print("You Loss")
	
func add_buff(buff: BaseBuff):
	self.buffManager.add_buff(buff)
	
func _on_mana_timer_timeout():
	self.state.MP = min(self.attr.maxMP, self.state.MP + self.attr.inspiration)
	emit_signal("stateChangeS")

func _on_cast_timer_timeout():
	self.canApplySpell = true

func _on_interact_area_area_entered(area):
	var item = area.get_parent()
	if is_instance_of(item, InteractableItem):
		item.preactivate(self)
