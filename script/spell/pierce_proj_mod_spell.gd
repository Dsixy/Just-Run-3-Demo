class_name PierceProjModSpell extends BaseSpell

static var spellName := "穿透投射物修饰"
static var description := "用以修饰【投射物】"
static var keys = ["投射物修饰"]
static var icon = ImageTexture.create_from_image(Image.load_from_file("res://resources/img/spell_icon/HitTriggerSpell.png"))
static var boardParams = {
	"maxPierceTime": ["穿透次数", 1, 5, 1]
}

var spellTree: SpellTreeNode
var subSpells: Array
var maxPierceTime: int = 0
var projectile: Node2D

func _init(spells: Array, spell_tree: SpellTreeNode):
	self.subSpells = spells
	self.spellTree = spell_tree
	
	self.process_extra_params(self.spellTree.extraParams)
	
func apply(attrDict: Dictionary):
	if self.projectile:
		self.projectile.maxPierceTime = self.maxPierceTime
	
func compute_cost_and_time():
	var cost := 2 * maxPierceTime
	var cast_time := 0.03 * maxPierceTime
	var arr := []
		
	self.manaCost = cost
	self.castTime = cast_time
	return [self.manaCost, self.castTime]
