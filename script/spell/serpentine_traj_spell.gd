class_name SerpentineTrajSpell extends BaseSpell

static var spellName := "蛇形轨迹"
static var description := "用以修饰【投射物】的轨迹，呈蛇形前进"
static var keys = ["投射物轨迹"]
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/SerpentineTrajSpell.png"))
static var boardParams = {
	"initSpeed": ["初始速度", 100, 1200, 100],
	"radius": ["运动半径", 50, 500, 50],
	"initDir": ["初始方向（上/下）", 0, 1, 1],
}

var spellTree: SpellTreeNode
var subSpells: Array
var traj_func: Callable

var initSpeed: int
var radius: int
var speed: int
var angle: float
var angSpeed: float
var velocity: Vector2 = Vector2.ONE
var clock: float = 0
var initDir: int
var projectile: Projectile

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	
	self.process_extra_params(self.spellTree.extraParams)
	self.speed = initSpeed
	self.angSpeed = self.speed * 1.0 / self.radius
	self.clock = initDir
	self.traj_func = func(delta, proj: Node2D):
		clock += delta * angSpeed
		if clock >= 2:
			clock -= 2
			
		if clock < 1:
			velocity = Vector2.from_angle((1 - clock) * PI + angle) * speed * delta
		else:
			velocity = Vector2.from_angle((clock - 1) * PI + angle) * speed * delta
		
		proj.global_position += velocity
		proj.rotation = velocity.angle()
	
func apply(attrDict: Dictionary):
	angle = (attrDict["target_position"] - attrDict["position"]).angle() - PI / 2
	
func compute_cost_and_time():
	var cost := 0
	var cast_time := 0.0
	var arr := []
		
	self.manaCost = cost
	self.castTime = cast_time
	return [self.manaCost, self.castTime]

