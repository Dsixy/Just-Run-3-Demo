extends UIBoard

@onready var HPLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HP/Label
@onready var MPLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MP/Label
@onready var maxHPLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MaxHP/Label
@onready var maxMPLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MaxMP/Label
@onready var speedLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Speed/Label
@onready var spellPowerLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/SpellPower/Label
@onready var inspirationLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Inspiration/Label
@onready var critRateLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/CritRate/Label
@onready var critDamageLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/CritDamage/Label

@onready var fireDamageBonusLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/FireDamageBonus/Label
@onready var frostDamageBonusLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/FrostDamageBonus/Label
@onready var bluntDamageBonusLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/BluntDamageBonus/Label
@onready var piercingDamageBonusLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PiercingDamageBonus/Label
@onready var posionDamageBonusLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PoisonDamageBonus/Label
@onready var forceDamageBonusLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/ForceDamageBonus/Label
@onready var lightningDamageBonusLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/LightningDamageBonus/Label
@onready var psychicDamageBonusLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PsychicDamageBonus/Label
@onready var slashDamageBonusLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/SlashDamageBonus/Label

var attrManager: AttrManager

func _init():
	self.boardName = "AttrBoard"

func set_player(p: BaseCharacter):
	super.set_player(p)
	attrManager = p.attrManager
	refresh_label()
	
func refresh_label():
	self.HPLabel.text = "生命值：{0}".format([str(attrManager.HP)])
	self.MPLabel.text = "法力值：{0}".format([str(attrManager.MP)])
	
	self.maxHPLabel.text = "最大生命值：{0} (+{1})".format([str(attrManager.maxHP.baseValue), str(attrManager.maxHP.extra_value())])
	self.maxMPLabel.text = "最大法力值：{0} (+{1})".format([str(attrManager.maxMP.baseValue), str(attrManager.maxMP.extra_value())])
	self.speedLabel.text = "速度：{0} (+{1})".format([str(attrManager.speed.baseValue), str(attrManager.speed.extra_value())])
	self.spellPowerLabel.text = "法术强度：{0} (+{1})".format([str(attrManager.spellPower.baseValue), str(attrManager.spellPower.extra_value())])
	self.inspirationLabel.text = "启迪值：{0} (+{1})".format([str(attrManager.inspiration.baseValue), str(attrManager.inspiration.extra_value())])
	
	self.critRateLabel.text = "法术暴击率：{0}".format([str(attrManager.critRate)])
	self.critDamageLabel.text = "法术暴击伤害：{0}".format([str(attrManager.critDamage)])
	
	self.fireDamageBonusLabel.text = "火焰伤害加成：{0}%".format([str(attrManager.damageBonus["Fire"] * 100)])
	self.frostDamageBonusLabel.text = "冰冻伤害加成：{0}%".format([str(attrManager.damageBonus["Frost"] * 100)])
	self.bluntDamageBonusLabel.text = "钝击伤害加成：{0}%".format([str(attrManager.damageBonus["Blunt"] * 100)])
	self.piercingDamageBonusLabel.text = "穿刺伤害加成：{0}%".format([str(attrManager.damageBonus["Piercing"] * 100)])
	self.posionDamageBonusLabel.text = "毒素伤害加成：{0}%".format([str(attrManager.damageBonus["Poison"] * 100)])
	self.lightningDamageBonusLabel.text = "雷电伤害加成：{0}%".format([str(attrManager.damageBonus["Force"] * 100)])
	self.fireDamageBonusLabel.text = "火焰伤害加成：{0}%".format([str(attrManager.damageBonus["Lightning"] * 100)])
	self.psychicDamageBonusLabel.text = "心灵伤害加成：{0}%".format([str(attrManager.damageBonus["Psychic"] * 100)])
	self.slashDamageBonusLabel.text = "挥砍伤害加成：{0}%".format([str(attrManager.damageBonus["Slash"] * 100)])
	self.forceDamageBonusLabel.text = "力场伤害加成：{0}%".format([str(attrManager.damageBonus["Force"] * 100)])
	
	
func _on_button_pressed():
	board_closeS.emit(self)

func close_board():
	queue_free()
