class_name TwinCastSpell extends ModifierSpell

func _init(spells: Array):
	spellName = "双重打包"
	
	var filter = ParamFilter.new()
	filter.description = "第一道咒语"
	filter.as_input = func(spell):
		return true
	self.filters.append(filter)
	
	filter = ParamFilter.new()
	filter.description = "第二道咒语"
	filter.as_input = func(spell):
		return true
	self.filters.append(filter)
	
	self.inputParams = spells
	
func apply(params):
	for spell in self.inputParams:
		spell.apply(params)
