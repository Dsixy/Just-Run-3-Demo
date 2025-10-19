class_name __ extends BaseSpell

static var spellName := "火球魔法"
static var description := ""
static var keys = ["Projection"]
static var filter: Callable = func(spellClass):
	return "ProjectionTraj" in spellClass
	
static var boardParams = [
	["轨迹", filter],
]

const fireballScene: PackedScene = preload("res://scene/item/fireball.tscn")
var spellTree: SpellTreeNode
var subSpells: Array

var extraCritDamage: float = 0.0

var projectile: Node2D

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	self.projectile = fireballScene.instantiate()
	
	if self.subSpells != []:
		self.projectile.traj_func = self.subSpells[0].traj_func
	
func apply(attr_dict: Dictionary):
	self.attrDict = attr_dict
	
	var damage = Damage.new(
		int(calculate_damage()),
		0,
		attr_dict["player_attr_info"].critRate,
		attr_dict["player_attr_info"].critDamage + self.extraCritDamage,
		Damage.DamageType.Fire
	)
	var overrideDict = {
		"damage": damage
	}
	self.projectile.override(overrideDict)
	
	attr_dict["mainscene"].add_child(self.projectile)
	self.projectile.global_position = attr_dict["position"]
	
	for spell: BaseSpell in self.subSpells:
		spell.apply(attr_dict)
		
func calculate_damage() -> float:
	return 10 + 0.5 * self.attrDict["player_attr_info"].spellPower
