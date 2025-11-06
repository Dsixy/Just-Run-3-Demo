extends Node

var availableSpell = [FireballSpell, SnowballSpell, LinearTrajSpell, OrbitWrapperSpell]
var spells = [null, null]

var buffDict = {
	"Chill": preload("res://scene/buff/chill_buff.tscn"),
	"Slow": preload("res://scene/buff/slow_buff.tscn"),
	"Haste": preload("res://scene/buff/haste_buff.tscn")
}
