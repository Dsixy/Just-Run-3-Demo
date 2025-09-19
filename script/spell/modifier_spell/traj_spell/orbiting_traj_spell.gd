class_name OrbitingTrajSpell extends ModifierSpell

var ang_vel: float
var radius: int
var direction: Vector2
var center: Node
var clock: float

func _init(spells: Array):
	spellName = "环绕轨迹"
	
	var filter = ParamFilter.new()
	
	filter.description = "环绕轨迹。用于修饰弹体类咒语，赋予弹体沿施法者环绕的轨迹"
	filter.as_input = func(spell):
		return spell.get("projectile") != null
		
	self.filters.append(filter)
	self.inputParams = spells
	
	ang_vel = 5.0
	radius = 150
	clock = 0
	
func apply(params: Dictionary):
	for spell in self.inputParams:
		spell.apply(params)
		
	center = params["applyer"]
	traj_hook()

func traj_hook():
	var projectile = self.inputParams[0].projectile
	projectile.traj_func = func(delta):
		self.clock += delta
		projectile.global_position = center.global_position + radius * Vector2.from_angle(clock * ang_vel)
		projectile.rotation = clock * ang_vel + PI / 2
