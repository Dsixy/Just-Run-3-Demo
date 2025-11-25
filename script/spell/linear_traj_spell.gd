class_name LinearTrajSpell extends BaseSpell

static var spellName := "线性轨迹"
static var description := "用以修饰【投射物】的轨迹"
static var keys = ["投射物轨迹"]
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/LinearTrajSpell.png"))
static var boardParams = {
	"initSpeed": ["初始速度", 100, 1500, 200]
}

var spellTree: SpellTreeNode
var subSpells: Array
var traj_func: Callable

var initSpeed: int = 200
var speed: int = 200
var velocity: Vector2 = Vector2.ONE
var projectile: Projectile

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	
	self.process_extra_params(self.spellTree.extraParams)
	self.speed = initSpeed
	self.traj_func = func(delta, proj: Node2D):
		proj.position += velocity * speed * delta
		proj.rotation = velocity.angle()
	
func apply(attrDict: Dictionary):
	velocity = (attrDict["target_position"] - attrDict["position"]).normalized()
	
func compute_cost_and_time():
	var cost := 0
	var cast_time := 0.0
	var arr := []
		
	self.manaCost = cost
	self.castTime = cast_time
	return [self.manaCost, self.castTime]
