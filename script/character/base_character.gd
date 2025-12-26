class_name BaseCharacter extends CharacterBody2D

var attrManager:= AttrManager.new()
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
	
	if cost > self.attrManager.MP:
		return
		
	self.attrManager.MP -= cost
	var dict = {
		"mainscene": get_parent(),
		"position": global_position,
		"target_position": get_global_mouse_position(),
		"player_attr_info": attrManager,
		"applier": self
	}
	spell.apply(dict)
	
	emit_signal("applySpellS")
	self.canApplySpell = false
	self.coolDownTimer.start(time)
	
	emit_signal("stateChangeS")
	
func _physics_process(delta):
	velocity = direction * attrManager.speed.final_value()
	move_and_slide()
	
func take_damage(damage: Damage):
	var final_damage_amount = damage.finalDamage
	FightInfoManager.show_damage_label(damage, global_position + Vector2.UP * 50)
	self.attrManager.set_state_value("HP", -final_damage_amount)
	emit_signal("stateChangeS")
	
	if self.attrManager.HP <= 0:
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
	self.attrManager.set_state_value("MP", self.attrManager.inspiration.final_value())
	emit_signal("stateChangeS")

func _on_cast_timer_timeout():
	self.canApplySpell = true

func _on_interact_area_area_entered(area):
	var item = area.get_parent()
	if is_instance_of(item, InteractableItem):
		item.preactivate(self)
