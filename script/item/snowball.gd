extends Projectile

func _init():
	self.duration = 6.0

func _on_hitbox_area_entered(area):
	if area.is_in_group(self.targetGroup):
		var target = area.get_parent()
		var buff = GameInfo.allocate_buff("Chill")
		target.take_damage(self.damage)
		target.add_buff(buff)
		emit_signal("hitS")
		delete()
