extends BaseEnemy

@onready var hitArea = $Feature/Hitbox

class MoveState extends State:
	func physics_process(delta):
		if self.stateOwner.target:
			var dir = (self.stateOwner.target.global_position - self.stateOwner.global_position).normalized()
			self.stateOwner.velocity = dir * self.stateOwner.attrManager.speed.final_value()
		else:
			self.stateOwner.velocity = Vector2.ZERO
		self.stateOwner.move_and_slide()
		
	func process(delta):
		if self.stateOwner.target and self.stateOwner.global_position.distance_to(self.stateOwner.target.global_position) <= 300:
			transiteStateS.emit(LeapState.new(self.stateOwner))
		
class LeapState extends State:
	var leap_speed := 0.0
	var direction := Vector2.ZERO

	func enter():
		self.stateOwner.hitArea.monitoring = true
		direction = (self.stateOwner.target.global_position - self.stateOwner.global_position).normalized()
		var tween = self.stateOwner.get_tree().create_tween()
		tween.tween_property(self, "leap_speed", 0, 0.7)
		tween.tween_property(self, "leap_speed", 1500.0, 0.2)
		tween.tween_property(self, "leap_speed", 0.0, 0.2)
		tween.tween_property(self, "leap_speed", 0, 0.4)
		
		await tween.finished
		if not is_instance_valid(self.stateOwner):
			return
			
		if self.stateOwner.global_position.distance_to(self.stateOwner.target.global_position) <= 300:
			transiteStateS.emit(LeapState.new(self.stateOwner))
		else:
			transiteStateS.emit(MoveState.new(self.stateOwner))

	func physics_process(delta):
		self.stateOwner.velocity = direction * leap_speed
		self.stateOwner.move_and_slide()
		
	func exit():
		self.stateOwner.hitArea.monitoring = false
	
var leapDamage: Damage

func _init():
	super._init()
	self.attrManager = AttrManager.new({
		"maxHP": 150
	})
	self.leapDamage = Damage.new(15, 0, 0, 0, "Blunt")
	
func set_target(t: Node2D):
	self.target = t
	
func activate():
	self.transite_to_state(MoveState.new(self))

func _on_hitbox_area_entered(area):
	if area.is_in_group(self.targetGroup):
		var target = area.get_parent()
		target.take_damage(self.leapDamage)
