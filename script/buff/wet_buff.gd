extends BaseBuff

var duration: float
var timer: float

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

func process_damage(damage: Damage):
	if damage.type == "Lightning":
		damage.bonus += 0.5
	return damage

func process_buff(buff: BaseBuff):
	if buff.buffName == "冰冻":
		var frozenBuff = GameInfo.allocate_buff("Frozen")
		buffOwner.add_buff(frozenBuff)
		buff.remove()
		remove()
