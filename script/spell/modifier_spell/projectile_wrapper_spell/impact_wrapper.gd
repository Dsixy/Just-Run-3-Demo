class_name ImpactWrapperSpell extends ModifierSpell

var projectile: Node2D
var params: Dictionary

func _init(spells: Array):
	spellName = "碰撞触发弹体"
	
	var filter = ParamFilter.new()
	filter.description = "主弹体。必须是弹体类型"
	filter.as_input = func(spell):
		return spell.get("projectile") != null
	self.filters.append(filter)
	
	filter = ParamFilter.new()
	filter.description = "触发咒。主弹体碰撞后发射的咒语"
	filter.as_input = func(spell):
		return true
	self.filters.append(filter)
	
	self.inputParams = spells
	projectile = spells[0].projectile
	
func apply(params: Dictionary):
	self.params = params
	self.inputParams[0].apply(params)
	
	impact_hook()
	
func impact_hook():
	projectile.expireS.connect(apply_new)
	
func apply_new():
	params["target"] -= params["position"]
	params["position"] = projectile.global_position
	params["target"] += params["position"]
	inputParams[1].apply(params)
