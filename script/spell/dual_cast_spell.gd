class_name DualCastSpell extends BaseSpell

static var spellName := "双重施法魔法"
static var description := ""
static var keys = ["多重施法"]
static var filter1: Callable = func(spellClass):
	return true
static var filter2: Callable = func(spellClass):
	return true
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/DoubleCastSpell.png"))
static var boardParams = {
	"firstSpell": ["源魔咒", filter1],
	"secondSpell": ["附加魔咒", filter2]
}

var spellTree: SpellTreeNode
var subSpells: Array

var firstSpell: BaseSpell
var secondSpell: BaseSpell


func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	
	self.process_extra_params(self.spellTree.extraParams)
	
	self.firstSpell = subSpells[0]
	self.secondSpell = subSpells[1]
	
func apply(attr_dict: Dictionary):
	self.attrDict = attr_dict
	
	if self.firstSpell:
		self.firstSpell.apply(attr_dict)
	if self.secondSpell:
		self.secondSpell.apply(attrDict)

func calculate_damage() -> float:
	return 0
	
func compute_cost_and_time():
	var cost := 5
	var cast_time := 0.1
	var arr := []
	var extraCost:= 0.0
	var extraCast:= 0.0
	
	if self.firstSpell:
		arr = self.firstSpell.compute_cost_and_time()
		extraCost = max(arr[0], extraCost)
		extraCast = max(arr[1], extraCast)
	if self.secondSpell:
		arr = self.secondSpell.compute_cost_and_time()
		extraCost = max(arr[0], extraCost)
		extraCast = max(arr[1], extraCast)
		
	self.manaCost = cost + extraCost
	self.castTime = cast_time + extraCast
	return [self.manaCost, self.castTime]
