class_name BounceTrajSpell extends BaseSpell

static var spellName := "弹射轨迹"
static var description := "用以修饰【投射物】的轨迹"
static var keys = ["投射物轨迹"]
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/HitTriggerSpell.png"))
static var boardParams = {
	"initSpeed": ["初始速度", 100, 1500, 200],
	"maxBounceTime": ["最大弹射次数", 1, 5, 1]
}

var spellTree: SpellTreeNode
var subSpells: Array
var traj_func: Callable

var initSpeed: int = 200
var speed: int = 200
var velocity: Vector2 = Vector2.ONE
var maxBounceTime: int = 1
var bounceTime: int = 0
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
	projectile.hitS.connect(_on_projectile_hit)
	projectile.maxBounceTime = maxBounceTime
	velocity = (attrDict["target_position"] - attrDict["position"]).normalized()
	
func _on_projectile_hit(body):
	if body and bounceTime < maxBounceTime:
		velocity = projectile.process_bounce_velocity(velocity)
	
func compute_cost_and_time():
	var cost := 0.03 * maxBounceTime
	var cast_time := 0.01 * maxBounceTime
	var arr := []
		
	self.manaCost = cost
	self.castTime = cast_time
	return [self.manaCost, self.castTime]
