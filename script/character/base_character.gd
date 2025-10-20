class_name BaseCharacter extends CharacterBody2D

class CharacterAttr:
	var maxHP: int = 100
	var speed: int = 250
	var critRate: float = 0.05
	var spellPower: int = 10
	var maxMP: int = 100
	var inspiration: float = 1.0
	var castSpeedModifier: float = 0.0
	var prosperity: float = 0.0
	var magicPenetration: float = 0.0
	var critDamage: float = 2.0
	
class CharacterState:
	var HP: float
	var MP: float

var attr: CharacterAttr
var state: CharacterState
var direction: Vector2

var spells = []

func _init():
	self.attr = CharacterAttr.new()
	self.state = CharacterState.new()
	self.spells.append(SpellTreeNode.new(SnowballSpell, {}, [SpellTreeNode.new(LinearTrajSpell)]))
	
func _input(event):
	direction = Vector2.ZERO
	if Input.is_action_pressed("MoveLeft"):
		direction.x = -1
	if Input.is_action_pressed("MoveRight"):
		direction.x = 1
	if Input.is_action_pressed("MoveUp"):
		direction.y = -1
	if Input.is_action_pressed("MoveDown"):
		direction.y = 1
		
	direction = direction.normalized()
	
	if Input.is_action_just_pressed("Apply"):
		apply_spell(GameInfo.spells[0])
		pass
	
func apply_spell(spellTree: SpellTreeNode):
	if spellTree == null:
		return
		
	spellTree.show()
	var spell = spellTree.cast()
	var dict = {
		"mainscene": get_parent(),
		"position": global_position,
		"target_position": get_global_mouse_position(),
		"player_attr_info": attr,
		"player_state_info": state
	}
	spell.apply(dict)
	
func _physics_process(delta):
	velocity = direction * attr.speed
	move_and_slide()
