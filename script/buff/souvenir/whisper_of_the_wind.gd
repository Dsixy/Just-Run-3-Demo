extends BaseBuff

# 属于【风之语】的效果Buff
# 当玩家施放咒语时，获得【风行】Buff

func _on_buff_applied():
	self.buffOwner.applySpellS.connect(_on_owner_apply_spell)
	
func _on_owner_apply_spell():
	var windStrideBuff = GameInfo.allocate_buff("WindStride")
	self.buffOwner.add_buff(windStrideBuff)
