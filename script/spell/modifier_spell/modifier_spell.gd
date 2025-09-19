class_name ModifierSpell extends Spell

func check_input_avaiable() -> bool:
	if len(self.inputParams) != len(self.filters):
		return false
		
	for i in range(len(self.inputParams)):
		if not self.filters[i].as_input.call(self.inputParams[i]):
			return false
			
	return true
