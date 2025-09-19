class_name Projectile extends Node2D

var traj_func: Callable
var clock: float
var duration: int
var params: Dictionary

signal hitS
signal expireS
signal deleteS

func _init():
	self.clock = 0
	self.traj_func = func(delta):
		return
	
func _ready():
	global_position = params["position"]
	
func _process(delta):
	self.clock += delta
	if self.clock >= self.duration:
		expire()
	
	self.traj_func.call(delta)
		
func expire():
	emit_signal("expireS")
	delete()

func delete():
	emit_signal("deleteS")
	queue_free()
