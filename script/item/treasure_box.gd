class_name TreasureBox extends InteractableItem

var content: Node2D
var room: Node2D

func _ready():
	room = get_parent()

func set_content(c: Node2D):
	self.content = c
	
func activate(sub: BaseCharacter):
	if room:
		room.add_child(content)
		content.position = position
		await get_tree().create_timer(1.0).timeout
		delete()

func delete():
	queue_free()
