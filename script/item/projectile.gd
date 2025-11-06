class_name Projectile extends Node2D

var traj_func: Callable = func(delta: float, node):
	return
	
var timer: float
var duration: float
var targetGroup: String = "enemy"

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
	
func _on_hitbox_body_entered(body):
	if body.is_in_group("wall"):
		var room = body.get_parent()
		room.take_damage(global_position, damage)
		emit_signal("hitS")
		delete()

func _on_hitbox_area_entered(area):
	if area.is_in_group(self.targetGroup):
		var target = area.get_parent()
		target.take_damage(self.damage)
		
		emit_signal("hitS")
		delete()
