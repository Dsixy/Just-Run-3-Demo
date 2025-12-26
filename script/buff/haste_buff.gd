extends BaseBuff

var duration: float
var timer: float
var shortedSpeed: int

func _ready():
	self.timer = 0
	self.duration = 0.5
	_on_buff_applied()
	
func stash():
	self.timer = 0
	
func _process(delta):
	self.timer += delta
	if self.timer >= self.duration:
		remove()

func _on_buff_applied():
	self.buffOwner.attrManager.speed.modify_extra_value(0.2)
	
func _on_buff_removed():
	self.buffOwner.attrManager.speed.modify_extra_value(-0.2)
