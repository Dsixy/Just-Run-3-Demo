class_name HomingTrajSpell extends BaseSpell

static var spellName := "追踪轨迹"
static var description := "用以修饰【投射物】的轨迹"
static var keys = ["投射物轨迹"]
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/OrbitWrapSpell.png"))
static var boardParams = {
	"initSpeed": ["初始速度", 100, 1500, 200],
}

var spellTree: SpellTreeNode
var subSpells: Array
var traj_func: Callable

var initSpeed: int = 200
var speed: int = 200
var velocity: Vector2 = Vector2.ONE
var projectile: Projectile
var target: Node2D
var targetVel: Vector2
var targetPos: Vector2

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	
	self.process_extra_params(self.spellTree.extraParams)
	self.speed = initSpeed
	self.traj_func = func(delta, proj: Node2D):
		if target and is_instance_valid(target):
			targetPos = target.global_position
		targetVel = (targetPos - proj.global_position)
		velocity = (velocity + targetVel * 0.2 * delta).normalized()
		proj.position += velocity * speed * delta
		proj.rotation = velocity.angle()
	
func apply(attrDict: Dictionary):
	velocity = Vector2.from_angle(randf() * TAU)
	targetPos = attrDict["target_position"]
	target = get_target(attrDict["target_position"])

func get_target(default: Vector2) -> Node2D:
	target = GameInfo.get_mouse_nearest_enemy()
	return target
	
func compute_cost_and_time():
	var cost := 0
	var cast_time := 0.0
	var arr := []
		
	self.manaCost = cost
	self.castTime = cast_time
	return [self.manaCost, self.castTime]
