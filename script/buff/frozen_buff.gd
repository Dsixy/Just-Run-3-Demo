extends BaseBuff

var duration: float
var timer: float
var shortedSpeed: int

func _ready():
	self.timer = 0
	self.duration = 4
	_on_buff_applied()
	
func stash():
	self.timer = 0
	
func _process(delta):
	self.timer += delta
	if self.timer >= self.duration:
		remove()

func _on_buff_applied():
	self.buffOwner.physicScale = 0
	self.buffOwner.processScale = 0
	
func _on_buff_removed():
	self.buffOwner.physicScale = 1
	self.buffOwner.processScale = 1
