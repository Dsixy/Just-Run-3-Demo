class_name State extends RefCounted

var stateOwner: Node2D
signal transiteStateS(nextState: State)
func _init(o: Node2D):
	self.stateOwner = o
	
func enter(): pass
func exit(): pass
func physics_process(delta: float): pass
func process(delta:float): pass
