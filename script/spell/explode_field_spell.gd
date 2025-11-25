class_name ExplodeFieldSpell extends BaseSpell

static var spellName := "爆炸魔法"
static var description := ""
static var keys = ["场"]
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/FireballSpell.png"))
static var boardParams = {
}

const explodeFieldScene: PackedScene = preload("res://scene/item/explode_field.tscn")
var spellTree: SpellTreeNode
var subSpells: Array
var field: Node2D

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	self.field = explodeFieldScene.instantiate()
	
	self.process_extra_params(self.spellTree.extraParams)
	
func apply(attr_dict: Dictionary):
	self.attrDict = attr_dict
	
	var damage = Damage.new(
		int(calculate_damage()),
		0,
		attr_dict["player_attr_info"].critRate,
		attr_dict["player_attr_info"].critDamage,
		"Force"
	)
	var overrideDict = {
		"damage": damage,
		"global_position": attr_dict["target_position"],
	}
	attr_dict["mainscene"].add_child(self.field)
	self.field.override(overrideDict)
	
func calculate_damage() -> float:
	return 60 + self.attrDict["player_attr_info"].spellPower
	
func compute_cost_and_time():
	var cost := 20
	var cast_time := 0.5
	var arr := []
	
	self.manaCost = cost
	self.castTime = cast_time
	return [self.manaCost, self.castTime]
