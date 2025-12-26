extends InteractableItem

@export var nextScene: PackedScene

func activate(p: BaseCharacter):
	GameInfo.mainscene.next_layer()
	

