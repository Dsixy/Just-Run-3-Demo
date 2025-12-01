extends Node2D

var mainscene: Node
@onready var mouseArea: Area2D = preload("res://scene/mouse_area.tscn").instantiate()

var buffDict = {
	"Chill": preload("res://scene/buff/chill_buff.tscn"),
	"Slow": preload("res://scene/buff/slow_buff.tscn"),
	"Haste": preload("res://scene/buff/haste_buff.tscn"),
	"Wet": preload("res://scene/buff/wet_buff.tscn"),
	"Frozen": preload("res://scene/buff/frozen_buff.tscn"),
	"WindStride": preload("res://scene/buff/wind_stride_buff.tscn")
}

var enemyDict = {
	"DuangDuangWorm": preload("res://scene/enemy/duang_duang_worm.tscn"),
	"WaterElemental": preload("res://scene/enemy/water_elemental.tscn"),
	"Bloverfly": preload("res://scene/enemy/bloverfly.tscn")
}


var potionList = {
	"LesserHealthPotion": preload("res://scene/item/potions/lesser_health_potion.tscn"),
	"FerocityPotion": preload("res://scene/item/potions/ferocity_potion.tscn"),
}

var souvenirList = {
	"WhisperOfTheWind": preload("res://scene/item/souvenir/whisper_of_the_wind.tscn")
}

var spellList = [
	FireballSpell,
	SnowballSpell,
	LinearTrajSpell,
	OrbitWrapperSpell,
	DoubleCastSpell,
	StoneConeSpell,
	SerpentineTrajSpell,
	DualCastSpell,
	BounceTrajSpell,
	OrbitTrajSpell,
]

	
func _ready():
	add_child(mouseArea)
	
func add_node(node: Node):
	mainscene.itemNode.add_child(node)
	
func allocate_timer(time: float) -> Timer:
	var timer = Timer.new()
	add_child(timer)
	timer.start(time)
	
	timer.connect("timeout", Callable(timer, "queue_free"))
	return timer

func allocate_buff(buffName: String):
	if buffName in self.buffDict:
		return buffDict[buffName].instantiate()
	else:
		push_warning("buff is not defined!")
		return preload("res://scene/buff/base_buff.tscn").instantiate()

func allocate_enemy(enemyName: String):
	if enemyName in enemyDict:
		return enemyDict[enemyName].instantiate()
	else:
		return null

func get_mouse_nearest_enemy():
	mouseArea.global_position = get_global_mouse_position()
	var list = mouseArea.get_overlapping_areas()
	var minDis = 150000
	var enemy = null
	var curDis
	
	for item: Node2D in list:
		if item.is_in_group("enemy"):
			curDis = item.global_position.distance_squared_to(mouseArea.global_position)
			if curDis < minDis:
				minDis = curDis
				enemy = item.get_parent()
	return enemy
