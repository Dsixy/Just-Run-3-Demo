class_name SerpentineTrajSpell extends ModifierSpell

var speed: int
var direction: Vector2
var clock: float
var angle: float

func _init(spells: Array):
	spellName = "蛇形轨迹"
	
	var filter = ParamFilter.new()
	
	filter.description = "蛇形轨迹。用于修饰弹体类咒语，赋予弹体朝向目标位置的三角函数轨迹"
	filter.as_input = func(spell):
		return spell.get("projectile") != null
		
	self.filters.append(filter)
	self.inputParams = spells
	
	speed = 300
	clock = 0.0
	
func apply(params: Dictionary):
	for spell in self.inputParams:
		spell.apply(params)
		
	angle = (params["target"] - params["position"]).angle() / PI - 0.5
	traj_hook()

func traj_hook():
	var projectile = self.inputParams[0].projectile
	projectile.traj_func = func(delta):
		clock += delta
		if clock >= 2:
			clock -= 2
			
		if clock < 1:
			direction = Vector2.from_angle((1 - clock + angle) * PI)
		else:
			direction = Vector2.from_angle((clock - 1 + angle) * PI)
		
		projectile.global_position += direction * speed * delta
		projectile.rotation = direction.angle()
