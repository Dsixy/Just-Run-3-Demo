extends Projectile

func _init():
	self.duration = 6.0
	
func override(params: Dictionary):
	self.damage = params["damage"]
	self.global_position = params["position"]
	self.rotation = params["rotation"]
