class_name BaseBuff extends Node

@export var ID: int
@export var buffName: String
@export var description: String

var buffOwner: Node2D
signal removeS(id: int)

func _ready():
	_on_buff_applied()
	
func stash():
	pass
	
func remove():
	_on_buff_removed()
	removeS.emit(self.ID)
	queue_free()
	
func _on_buff_applied():
	pass
	
func _on_buff_removed():
	pass
	
func _process(delta):
	pass

func process_damage(damage: Damage) -> Damage:
	return damage
	
func process_buff(buff: BaseBuff):
	return 
