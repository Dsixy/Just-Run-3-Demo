extends ProgressBar

var barOwner: BaseEnemy

func set_bar_owner(o: BaseEnemy):
	self.barOwner = o
	self.max_value = o.attrManager.maxHP.final_value()
	self.value = self.max_value
	
	self.barOwner.HPChangeS.connect(refresh)
	self.barOwner.deathS.connect(queue_free)
	
func refresh():
	self.value = barOwner.attrManager.HP
