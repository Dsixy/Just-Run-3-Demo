extends BaseBuff

# 属于水精灵的特质
# 默认状态下，水精灵获得除火焰伤害、雷电伤害的全伤害免疫
# 水精灵每0.5s为自身施加【潮湿】Buff
# 当获得【冻结】Buff时，水精灵全伤害免疫失效。收到【钝击】【力场】伤害将必定暴击
var isFrozen: bool = false

func _on_buff_applied():
	self.buffOwner.damageScaleManager.set_damage_immu([
		"Blunt", "Piercing", "Poison", "Frost", "Psychic", "Force"
	], true)
		
func _on_timer_timeout():
	var wetBuff = GameInfo.allocate_buff("Wet")
	self.buffOwner.add_buff(wetBuff)

func process_buff(buff: BaseBuff):
	if buff.buffName == "冻结":
		self.buffOwner.damageScaleManager.set_damage_immu([
			"Blunt", "Piercing", "Force"
		], false)
		buff.removeS.connect(_on_frozen_buff_removed)
		isFrozen = true
		
func process_damage(damage: Damage):
	if isFrozen and damage.type in ["Blunt", "Force"]:
		damage.isCrit = true
	return damage

func _on_frozen_buff_removed():
	isFrozen = false
	self.buffOwner.damageScaleManager.set_damage_immu([
		"Blunt", "Piercing", "Poison", "Frost", "Psychic", "Force"
	], true)
