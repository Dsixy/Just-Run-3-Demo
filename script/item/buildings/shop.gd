extends Node2D

@onready var spellItemScene = preload("res://scene/item/spell_item.tscn")
@onready var souvenirScene = preload("res://scene/item/souvenir_item.tscn")
@onready var slots = [
	$ShopSlot, $ShopSlot2, $ShopSlot3
]

enum TYPE {
	SPELL, POTION, SOUVENIR
}
@export var shopType: TYPE
@export var random: bool = true

func _ready():
	if random:
		self.shopType = [TYPE.SPELL, TYPE.POTION, TYPE.SOUVENIR].pick_random()
	set_type(self.shopType)
	
func set_type(t: TYPE):
	self.shopType = t
	match t:
		TYPE.SPELL: set_spell_goods()
		TYPE.POTION: set_potion_goods()
		TYPE.SOUVENIR: set_souvenir_goods()
		
func set_spell_goods():
	for slot in slots:
		var spellItem = spellItemScene.instantiate()
		var spell = GameInfo.spellList.pick_random()
		spellItem.set_spell_type(spell)
		slot.set_content(spellItem)
		slot.set_price(10)
	
func set_potion_goods():
	for slot in slots:
		var potionName = GameInfo.potionList.keys().pick_random()
		var potion = GameInfo.potionList[potionName].instantiate()
		slot.set_content(potion)
		slot.set_price(10)
	
func set_souvenir_goods():
	for slot in slots:
		var item = souvenirScene.instantiate()
		var souvenirName = GameInfo.souvenirList.keys().pick_random()
		var souvenir = GameInfo.souvenirList[souvenirName].instantiate()
		slot.set_content(item)
		item.set_souvenir(souvenir)
		slot.set_price(10)
