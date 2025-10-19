class_name Projectile extends Node2D

var traj_func: Callable = func(delta: float, node):
	return
	
var timer: float
var duration: float

var damage: Damage

signal hitS
signal expireS
signal deleteS

func _init():
	self.duration = 4.0

func _process(delta):
	timer += delta
	
	self.traj_func.call(delta, self)
	
	if timer >= duration:
		expire()

func expire():
	emit_signal("expireS")
	delete()
	
func delete():
	emit_signal("deleteS")
	queue_free()
	
func _on_area_2d_area_entered(area):
	pass # Replace with function body.
