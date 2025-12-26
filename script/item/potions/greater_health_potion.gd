extends Potion

func activate(p: BaseCharacter):
	p.attrManager.set_state_value("HP", 200)
	delete()

func delete():
	queue_free()
