extends InteractableItem

var content: InteractableItem
var price: int
var isSold: bool

func set_content(c: InteractableItem):
	self.content = c
	add_child(c)
	self.content.interactable = false

func set_price(p: int):
	self.price = p
	
func activate(p: BaseCharacter):
	if isSold:
		return
	elif p.couponManager.couponValue < price:
		return
	else:
		p.couponManager.cost_coupon(price)
		self.content.interactable = true
		isSold = true
