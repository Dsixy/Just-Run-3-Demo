class_name LinearTrajSpell extends BaseSpell

static var spellName := "线性轨迹"
static var description := "用以修饰【投射物】的轨迹"
static var keys = ["ProjectionTraj"]
	
static var boardParams = [
	["初始速度", 100, 600, 100]
]

var spellTree: SpellTreeNode
var subSpells: Array
var traj_func: Callable

var speed: int = 200
var velocity: Vector2 = Vector2.ONE

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	self.traj_func = func(delta, projectile: Node2D):
		projectile.position += velocity * speed * delta
	
func apply(attrDict: Dictionary):
	velocity = (attrDict["target_position"] - attrDict["position"]).normalized()
	
func compute_cost_and_time():
	var cost := 0
	var cast_time := 0.1
	var arr := []
		
	self.manaCost = cost
	self.castTime = cast_time
	return [cost, cast_time]
