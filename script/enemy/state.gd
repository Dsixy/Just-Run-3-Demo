class_name State extends RefCounted

var stateOwner: Node2D
signal transiteStateS(nextState: State)
func _init(o: Node2D):
	self.stateOwner = o
	
func enter(): pass
func exit(): pass
func physics_process(delta: float): pass
func process(delta:float): pass
func get_target_relative_position() -> Vector2:
	if not self.stateOwner or not self.stateOwner.get("target"):
		push_warning("You should set stateOwner's target to compute target distance!")
		return Vector2.ONE
		
	return self.stateOwner.target.global_position - self.stateOwner.global_position
	
func get_target_distance():
	return get_target_relative_position().length()
