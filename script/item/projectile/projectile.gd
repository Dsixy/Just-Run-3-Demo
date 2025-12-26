class_name Projectile extends Node2D

@onready var collisionDetector = $RayCast2D
var traj_func: Callable = func(delta: float, node):
	return
	
var timer: float
var duration: float
var targetGroup: String = "enemy"
var maxBounceTime: int = 0
var currentBounceTime: int = 0

var maxPierceTime: int = 0
var currentPierceTime: int = 0

var trajSpell: BaseSpell
var damage: Damage
var propNameList: Array

signal hitS(body)
signal expireS
signal deleteS

func _init():
	self.duration = 4.0
	
func _ready():
	var propList = get_property_list()
	for prop in propList:
		propNameList.append(prop["name"])

func _process(delta):
	timer += delta
	self.traj_func.call(delta, self)
	if timer >= duration:
		expire()

func override(params: Dictionary):		
	for key in params.keys():
		if key in propNameList:
			self.set(key, params[key])
	if self.trajSpell:
		self.traj_func = trajSpell.traj_func

func expire():
	emit_signal("expireS")
	delete()
	
func delete():
	emit_signal("deleteS")
	queue_free()
	
func process_bounce_velocity(vel: Vector2) -> Vector2:
	var normal = collisionDetector.get_collision_normal()
	return vel.bounce(normal)

func _on_hitbox_body_entered(body):
	if body.is_in_group("wall"):
		var room = body.get_parent()
		room.take_damage(global_position, damage.copy())
		hitS.emit(body)
		if currentBounceTime < maxBounceTime:
			currentBounceTime += 1
		else:
			delete()

func _on_hitbox_area_entered(area):
	if area.is_in_group(self.targetGroup):
		var target = area.get_parent()
		target.take_damage(self.damage.copy())
		
		hitS.emit(null)
		if currentPierceTime < maxPierceTime:
			currentPierceTime += 1
		else:
			delete()
