class_name BarrageSpell extends BaseSpell

static var spellName := "法术倾泻"
static var description := ""
static var keys = ["法术修正"]
static var filter: Callable = func(spellClass):
	return true
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/DoubleCastSpell.png"))
static var boardParams = {
	"targetSpell": ["源魔咒", filter],
	"castRate": ["加速比", 0.8, 0.9, 0.01]
}

var spellTree: SpellTreeNode
var subSpells: Array
var castRate: float
var targetSpell: BaseSpell

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	self.process_extra_params(self.spellTree.extraParams)
	
	self.targetSpell = subSpells[0]
	
func apply(attr_dict: Dictionary):
	self.attrDict = attr_dict
	
	if self.targetSpell:
		self.targetSpell.apply(attr_dict)

func calculate_damage() -> float:
	return 0
	
func compute_cost_and_time():
	var cost := roundf(3 / (1 - castRate))
	var cast_time := 0.0
	var arr := []
	
	if self.targetSpell:
		arr = self.targetSpell.compute_cost_and_time()
		cost += arr[0]
		cast_time += arr[1]
	
	self.manaCost = cost
	self.castTime = cast_time * (1 - castRate)
	return [self.manaCost, self.castTime]
