extends Potion

func activate(p: BaseCharacter):
	p.attr.modify_attr("critRate", 0.05)
	delete()

func delete():
	queue_free()
