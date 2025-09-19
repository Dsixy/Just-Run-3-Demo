class_name OrbitingWrapperSpell extends ModifierSpell

var projectile: Node2D
var ang_vel: float
var radius: int
var subprojectiles: Array

func _init(spells: Array):
	spellName = "环绕效果弹体"
	
	var filter = ParamFilter.new()
	
	filter.description = "主弹体。必须是弹体类型"
	filter.as_input = func(spell):
		return spell.get("projectile") != null
	self.filters.append(filter)
	
	for i in range(3):
		var filter_ = ParamFilter.new()
		filter_.description = "环绕弹体。必须是弹体类型"
		filter_.as_input = func(spell):
			return spell.get("projectile") != null
		self.filters.append(filter_)
	
	self.inputParams = spells
	
	projectile = spells[0].projectile
	subprojectiles = spells.duplicate()
	subprojectiles.pop_front()
	ang_vel = 10
	radius = 50
	
func apply(params: Dictionary):
	for spell in subprojectiles:
		spell.apply(params)
		
	traj_hook()
	free_hook()
	self.inputParams[0].apply(params)
	
func traj_hook():
	var proj_num = len(subprojectiles)
	
	for i in range(proj_num):
		subprojectiles[i].projectile.traj_func = func(delta):
			subprojectiles[i].projectile.global_position = \
				projectile.global_position + \
				radius * Vector2.from_angle(projectile.clock * ang_vel + i * 2 * PI / proj_num)
			subprojectiles[i].projectile.rotation = projectile.clock * ang_vel + i * 2 * PI / proj_num + PI / 2
			
				
func free_hook():
	projectile.deleteS.connect(delete_sub)
	
func delete_sub():
	for spell in subprojectiles:
		if is_instance_valid(spell.projectile):
			spell.projectile.delete()
