extends BaseBuff

#static var ID:= 0
#static var buffName:= "冰冻"
#static var description:= ""

var duration: float
var timer: float
var shortedSpeed: int

func _ready():
	self.timer = 0
	self.duration = 5
	_on_buff_applied()
	
func stash():
	self.timer = 0
	
func _process(delta):
	self.timer += delta
	if self.timer >= self.duration:
		remove()

func _on_buff_applied():
	self.shortedSpeed = self.buffOwner.attr.speed * 0.3
	self.buffOwner.attr.speed -= self.shortedSpeed
	
func _on_buff_removed():
	self.buffOwner.attr.speed += self.shortedSpeed

func process_damage(damage: Damage):
	if damage.type == "Fire":
		self.timer += 1
	return damage
