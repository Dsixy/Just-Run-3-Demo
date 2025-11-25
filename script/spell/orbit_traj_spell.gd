class_name OrbitTrajSpell extends BaseSpell

static var spellName := "环绕轨迹"
static var description := "用以修饰【投射物】的轨迹"
static var keys = ["投射物轨迹"]
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/OrbitWrapSpell.png"))
static var boardParams = {
	"initSpeed": ["初始速度", 100, 1500, 200],
	"radius": ["环绕半径", 50, 650, 50],
	"initDirection": ["顺（逆时针）", -1, 1, 2],
	"initPhase": ["初始相位", 0, 6.24, 0.06]
}

var spellTree: SpellTreeNode
var subSpells: Array
var traj_func: Callable

var initSpeed: int = 200
var speed: int = 200
var velocity: Vector2 = Vector2.ONE
var radius: int
var initDirection: int
var initPhase: float
var projectile: Projectile
var clock: float = 0
var center: Node2D
var angVel: float

var finalAng: float

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	
	self.process_extra_params(self.spellTree.extraParams)
	self.speed = initSpeed
	self.angVel = self.speed / self.radius * self.initDirection
	self.traj_func = func(delta, proj: Node2D):
		self.clock += delta
		self.finalAng = initPhase + clock * angVel
		proj.global_position = center.global_position + radius * Vector2.from_angle(finalAng)
		proj.rotation = self.finalAng + PI * self.initDirection / 2
	
func apply(attrDict: Dictionary):
	center = attrDict["applier"]

func get_target():
	pass
	
func compute_cost_and_time():
	var cost := 0
	var cast_time := 0.0
	var arr := []
		
	self.manaCost = cost
	self.castTime = cast_time
	return [self.manaCost, self.castTime]
