class_name FireballSpell extends BaseSpell

static var spellName := "火球魔法"
static var description := ""
static var keys = ["投射物"]
static var filter: Callable = func(spellClass):
	return "投射物轨迹" in spellClass.keys
	
static var boardParams = {
	"trajSpell": ["轨迹", filter],
}

const fireballScene: PackedScene = preload("res://scene/item/fireball.tscn")
var spellTree: SpellTreeNode
var subSpells: Array

var trajSpell: BaseSpell

var extraCritDamage: float = 0.0

var projectile: Node2D

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	self.projectile = fireballScene.instantiate()
	
	self.process_extra_params(self.spellTree.extraParams)
	
	self.trajSpell = subSpells[0]
	if self.trajSpell:
		self.projectile.traj_func = self.trajSpell.traj_func
	
func apply(attr_dict: Dictionary):
	self.attrDict = attr_dict
	
	var damage = Damage.new(
		int(calculate_damage()),
		0,
		attr_dict["player_attr_info"].critRate,
		attr_dict["player_attr_info"].critDamage + self.extraCritDamage,
		"Fire"
	)
	var overrideDict = {
		"damage": damage,
		"position": attr_dict["position"],
		"rotation": (attr_dict["target_position"] - attr_dict["position"]).angle()
	}
	attr_dict["mainscene"].add_child(self.projectile)
	self.projectile.override(overrideDict)
	
	if self.trajSpell:
		self.trajSpell.apply(attr_dict)
		
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
		
	self.manaCost = cost
	self.castTime = cast_time
	return [cost, cast_time]
