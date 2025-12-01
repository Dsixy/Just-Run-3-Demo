extends BaseBuff

var duration: float
var timer: float
var extraSpeed: int
var speed: int

func _ready():
	self.timer = 0
	self.duration = 1.8
	_on_buff_applied()
	
func stash():
	self.timer = 0

func _process(delta):
	self.timer += delta
	if self.timer >= self.duration:
		remove()

func _on_buff_applied():
	self.extraSpeed = self.buffOwner.attr.speed * 0.6
	self.buffOwner.attr.speed += self.extraSpeed
	
func _on_buff_removed():
	self.buffOwner.attr.speed -= self.extraSpeed
