extends Potion

func activate(p: BaseCharacter):
	p.state.modify_state("HP", 50)
	delete()

func delete():
	queue_free()
