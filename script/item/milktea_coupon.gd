extends InteractableItem

var value: int

func set_value(v: int):	
	self.value = v
	
func activate(p: BaseCharacter):
	p.couponManager.add_coupon(value)
	queue_free()

func preactivate(p: BaseCharacter):
	activate(p)
