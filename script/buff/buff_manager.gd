extends Node

var buffDict: Dictionary = {}

func add_buff(buff: BaseBuff):
	var buffID = buff.ID
	if buffID not in self.buffDict:
		buff.buffOwner = get_parent()
		self.buffDict[buffID] = buff
		add_child(buff)
		buff.removeS.connect(remove_buff)
	else:
		self.buffDict[buffID].stash()

func remove_buff(id: int):
	if id in self.buffDict:
		#self.buffDict[id].remove()s
		#remove_child(self.buffDict[id])
		self.buffDict.erase(id)

func process_damage(damage: Damage):
	for buff in self.buffDict:
		damage = self.buffDict[buff].process_damage(damage)
		
	return damage
