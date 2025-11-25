class_name OrbitWrapperSpell extends BaseSpell

static var spellName := "环绕弹体"
static var description := ""
static var keys = ["投射物"]
static var filter: Callable = func(spellClass):
	return "投射物" in spellClass.keys
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/OrbitWrapSpell.png"))
static var boardParams = {
	"projSpell": ["源投射物【必要】", filter],
	"projNum": ["包围个数", 1, 6, 1],
	"radius": ["环绕半径", 50, 250, 10],
	"angVel": ["环绕角速度", 0, 6, 0.2]
}

var spellTree: SpellTreeNode
var subSpells: Array

var projSpell: BaseSpell
var projNum: int 
var timers := []
var radius: int
var angVel: float

var projectile: Node2D
var subProjectile := []

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	
	self.process_extra_params(self.spellTree.extraParams)
	
	self.projSpell = self.subSpells[0]
	if self.projSpell and self.projSpell.projectile:
		self.projectile = self.projSpell.projectile
		self.projectile.deleteS.connect(_on_projectile_deleted)
	for i in range(self.projNum):
		self.timers.append(0)
	
func apply(attr_dict: Dictionary):
	self.attrDict = attr_dict
	
	if self.projectile == null:
		return
	
	if self.projSpell:
		self.projSpell.apply(attr_dict)
		
	var initPhase = randf() * TAU
	for i in range(self.projNum):
		var index := i

		var proj_spell = self.spellTree.subNodes[0].copy()
			
		var spell = proj_spell.cast()
		var phase = initPhase + (TAU / self.projNum) * index
		spell.apply(attr_dict)
		
		if spell.projectile == null:
			continue
			
		spell.projectile.traj_func = func(delta, node):
			self.timers[index] += delta
			var p = phase + self.timers[index] * self.angVel
			node.global_position = self.projectile.global_position + \
				self.radius * Vector2.from_angle(p)
			node.rotation = p + PI / 2

		self.subProjectile.append(spell.projectile)
	
func _on_projectile_deleted():
	for subP in self.subProjectile:
		if subP and is_instance_valid(subP):
			subP.queue_free()
	self.subProjectile = []
	
func compute_cost_and_time():
	var cost := 0
	var cast_time := 0.1
	var arr := []
	
	if self.projSpell:
		arr = self.projSpell.compute_cost_and_time()
		cost += arr[0] * self.projNum
		cast_time += arr[1] * self.projNum * 0.05 + arr[1] * 0.95
		
	self.manaCost = cost
	self.castTime = cast_time
	return [self.manaCost, self.castTime]

