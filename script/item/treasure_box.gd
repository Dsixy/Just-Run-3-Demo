class_name TreasureBox extends InteractableItem

@export var spell: GDScript
var content: Node2D
var room: Node2D

signal onBoxOpenedS

func _ready():
	room = get_parent()
	
	if spell:
		var spellItem = preload("res://scene/item/spell_item.tscn").instantiate()
		spellItem.set_spell_type(spell)
		self.set_content(spellItem)

func set_content(c: Node2D):
	self.content = c
	
func activate(sub: BaseCharacter):
	if room and interactable:
		interactable = false
		room.add_child(content)
		content.position = position
		
		FightInfoManager.flagManager.set_flag("treasure_box_opened")
		onBoxOpenedS.emit()
		
		await get_tree().create_timer(1.0).timeout
		delete()

func delete():
	queue_free()
