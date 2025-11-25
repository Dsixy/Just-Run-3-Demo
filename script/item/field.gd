class_name Field extends Node2D

var timer: float
var duration: float
var targetGroup: String = "enemy"
var damage: Damage
var propNameList: Array

signal hitS(body)
signal expireS
signal deleteS

func _init():
	self.duration = 0.5

func _ready():
	var propList = get_property_list()
	for prop in propList:
		propNameList.append(prop["name"])

func override(params: Dictionary):		
	for key in params.keys():
		if key in propNameList:
			self.set(key, params[key])
			
func _process(delta):
	timer += delta
	
	if timer >= duration:
		expire()

func expire():
	emit_signal("expireS")
	delete()
	
func delete():
	emit_signal("deleteS")
	queue_free()

func _on_hitbox_area_entered(area):
	if area.is_in_group(self.targetGroup):
		var target = area.get_parent()
		target.take_damage(self.damage.copy())
		hitS.emit(area)

func _on_hitbox_body_entered(body):
	if body.is_in_group("wall"):
		var room = body.get_parent()
		room.take_damage(global_position, damage.copy())
		hitS.emit(body)
