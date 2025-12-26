extends Potion

func activate(p: BaseCharacter):
	p.attrManager.set_state_value("HP", 50)
	delete()

func delete():
	queue_free()
