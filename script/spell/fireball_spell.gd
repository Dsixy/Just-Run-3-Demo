class_name FireballSpell extends BaseSpell

static var spellName := "火球魔法"
static var description := ""
static var keys = ["投射物"]
static var filter: Callable = func(spellClass):
	return "投射物轨迹" in spellClass.keys
static  var modifierFilter: Callable = func(spellClass):
	return "投射物修饰" in spellClass.keys
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/FireballSpell.png"))
static var boardParams = {
	"trajSpell": ["轨迹", filter],
	"modifier1": ["投射物修饰【1】", modifierFilter],
	"modifier2": ["投射物修饰【2】", modifierFilter],
	"modifier3": ["投射物修饰【3】", modifierFilter],
}

const fireballScene: PackedScene = preload("res://scene/item/fireball.tscn")
var spellTree: SpellTreeNode
var subSpells: Array
var trajSpell: BaseSpell
var projectile: Node2D

var modifier1: BaseSpell
var modifier2: BaseSpell
var modifier3: BaseSpell

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	self.projectile = fireballScene.instantiate()
	
	self.process_extra_params(self.spellTree.extraParams)
	
	self.trajSpell = subSpells[0]		
	self.modifier1 = subSpells[1]
	self.modifier2 = subSpells[2]
	self.modifier3 = subSpells[3]
	if self.trajSpell:
		self.trajSpell.projectile = projectile
	
func apply(attr_dict: Dictionary):
	self.attrDict = attr_dict
	
	var damage = Damage.new(
		int(calculate_damage()),
		0,
		attr_dict["player_attr_info"].critRate,
		attr_dict["player_attr_info"].critDamage,
		"Fire"
	)
	var overrideDict = {
		"damage": damage,
		"position": attr_dict["position"],
		"rotation": (attr_dict["target_position"] - attr_dict["position"]).angle(),
		"trajSpell": trajSpell
	}
	attr_dict["mainscene"].add_child(self.projectile)
	self.projectile.override(overrideDict)
	
	if self.trajSpell:
		self.trajSpell.apply(attr_dict)
	if self.modifier1:
		self.modifier1.projectile = projectile
		self.modifier1.apply(attr_dict)
	if self.modifier2:
		self.modifier2.projectile = projectile
		self.modifier2.apply(attr_dict)
	if self.modifier3:
		self.modifier3.projectile = projectile
		self.modifier3.apply(attr_dict)
		
func calculate_damage() -> float:
	return 20 + 0.5 * self.attrDict["player_attr_info"].spellPower
	
func compute_cost_and_time():
	var cost := 5
	var cast_time := 0.5
	var arr := []
	
	if self.trajSpell:
		arr = self.trajSpell.compute_cost_and_time()
		cost += arr[0]
		cast_time += arr[1]
	if self.modifier1:
		arr = self.modifier1.compute_cost_and_time()
		cost += arr[0]
		cast_time += arr[1]
	if self.modifier2:
		arr = self.modifier2.compute_cost_and_time()
		cost += arr[0]
		cast_time += arr[1]
	if self.modifier3:
		arr = self.modifier3.compute_cost_and_time()
		cost += arr[0]
		cast_time += arr[1]
	self.manaCost = cost
	self.castTime = cast_time
	return [self.manaCost, self.castTime]
