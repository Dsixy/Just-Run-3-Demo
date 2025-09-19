class_name BasePlayer extends CharacterBody2D

var direction: Vector2
var speed: int

func _init():
	speed = 400
	
func _input(event):
	direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_up"):
		direction.y = -1
	if Input.is_action_pressed("move_down"):
		direction.y = 1
		
	direction = direction.normalized()
	
	if Input.is_action_just_pressed("apply_spell"):
		apply_spell()
	
func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

func apply_spell():
	#var spell = FireballSpell.new()
	#var center_spell = FireballSpell.new()
	#var kspell = LinearTrajSpell.new([
		#OrbitingWrapperSpell.new([center_spell, IceballSpell.new(), IceballSpell.new(), IceballSpell.new()])
	#])
	#
	#var wrapper = ImpactWrapperSpell.new([spell, kspell])
	#var traj_spell = OrbitingTrajSpell.new([wrapper])

	var spell = GameInfo.spellTree.create_spell()
	var params = {
		"position": global_position,
		"bulletNode": get_parent(),
		"target": get_global_mouse_position(),
		"applyer": self
	}
	spell.apply(params)
