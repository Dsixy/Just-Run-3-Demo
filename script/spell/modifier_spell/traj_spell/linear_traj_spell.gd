class_name LinearTrajSpell extends ModifierSpell

var speed: int
var direction: Vector2

func _init(spells: Array):
	spellName = "线性轨迹"
	
	var filter = ParamFilter.new()
	
	filter.description = "线性轨迹。用于修饰弹体类咒语，赋予弹体朝向目标位置的直线轨迹"
	filter.as_input = func(spell):
		return spell.get("projectile") != null
		
	self.filters.append(filter)
	self.inputParams = spells
	
	speed = 400
	
func apply(params: Dictionary):
	for spell in self.inputParams:
		spell.apply(params)
		
	direction = (params["target"] - params["position"]).normalized()
	traj_hook()

func traj_hook():
	var projectile = self.inputParams[0].projectile
	projectile.traj_func = func(delta):
		projectile.global_position += direction * speed * delta
		projectile.rotation = direction.angle()
