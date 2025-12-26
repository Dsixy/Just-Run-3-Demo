extends Potion

func activate(p: BaseCharacter):
	p.attrManager.critRate += 0.05
	delete()

func delete():
	queue_free()
