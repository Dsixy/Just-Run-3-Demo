extends Projectile

func _init():
	self.duration = 6.0
	
func override(params: Dictionary):
	self.damage = params["damage"]
	self.global_position = params["position"]
	self.rotation = params["rotation"]

func _on_area_2d_area_entered(area):
	if area.is_in_group(self.targetGroup):
		var target = area.get_parent()
		var buff = GameInfo.buffDict["Chill"].instantiate()
		
		target.take_damage(self.damage)
		target.add_buff(buff)
		emit_signal("hitS")
		delete()
