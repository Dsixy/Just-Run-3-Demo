extends BaseEnemy

var speed: int = 100

class MoveState extends State:
	func physics_process(delta):
		if self.stateOwner.target:
			var dir = (self.stateOwner.target.global_position - self.stateOwner.global_position).normalized()
			self.stateOwner.velocity = dir * self.stateOwner.speed
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
		direction = (self.stateOwner.target.global_position - self.stateOwner.global_position).normalized()
		var tween = self.stateOwner.get_tree().create_tween()
		tween.tween_property(self, "leap_speed", 0, 0.7)
		tween.tween_property(self, "leap_speed", 1500.0, 0.2)
		tween.tween_property(self, "leap_speed", 0.0, 0.2)
		tween.tween_property(self, "leap_speed", 0, 0.4)
		
		await tween.finished
		if self.stateOwner.global_position.distance_to(self.stateOwner.target.global_position) <= 300:
			transiteStateS.emit(LeapState.new(self.stateOwner))
		else:
			transiteStateS.emit(MoveState.new(self.stateOwner))

	func physics_process(delta):
		self.stateOwner.velocity = direction * leap_speed
		self.stateOwner.move_and_slide()
	
func set_target(t: Node2D):
	self.target = t
	
func _ready():
	self.transite_to_state(MoveState.new(self))
