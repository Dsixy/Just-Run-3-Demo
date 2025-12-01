extends InteractableItem

@onready var sprite = $Graphic/Sprite2D
var souvenir: Souvenir

func set_souvenir(s: Souvenir):
	self.souvenir = s
	sprite.texture = self.souvenir.texture
	
func activate(p: BaseCharacter):
	var buff = self.souvenir.buff.instantiate()
	p.add_buff(buff)
	queue_free()

func delete():
	queue_free()
