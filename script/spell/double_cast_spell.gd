class_name DoubleCastSpell extends BaseSpell

static var spellName := "双重拷贝魔法"
static var description := ""
static var keys = ["拷贝魔法"]
static var filter: Callable = func(spellClass):
	return true
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/DoubleCastSpell.png"))
static var boardParams = {
	"targetSpell": ["源魔咒", filter],
}

var spellTree: SpellTreeNode
var subSpells: Array

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
		var self_ref = self
		
		var timer = GameInfo.allocate_timer(0.1)
		await timer.timeout
		timer.queue_free()
		
		var copiedSpell = self.targetSpell.spellTree.cast()
		copiedSpell.apply(attrDict)
		self_ref = null

func calculate_damage() -> float:
	return 0
	
func compute_cost_and_time():
	var cost := 5
	var cast_time := 0.33
	var arr := []
	
	if self.targetSpell:
		arr = self.targetSpell.compute_cost_and_time()
		cost += arr[0] * 1.5
		cast_time += arr[1]
		
	self.manaCost = cost
	self.castTime = cast_time
	return [self.manaCost, self.castTime]

