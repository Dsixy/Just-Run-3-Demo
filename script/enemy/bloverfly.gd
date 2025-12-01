extends BaseEnemy

@onready var waterballScene = preload("res://scene/item/fireball.tscn")
	
var attackCoolDownInterval: float = 2.0
var canAttack: bool = true
	
class MoveState extends State:
	var attackMinDis: int = 300
	var attackMaxDis: int = 800
	var dirScale: int = 1
		
	func physics_process(delta):
		if self.stateOwner.target:
			var dir = self.get_target_relative_position().normalized()
			self.stateOwner.velocity = dir * self.stateOwner.attr.speed * self.dirScale
		else:
			self.stateOwner.velocity = Vector2.ZERO
		self.stateOwner.move_and_slide()
		
	func process(delta):
		self.attackMinDis -= delta * 100
		if self.stateOwner.target:
			var dis = get_target_distance()
			if dis > self.attackMaxDis:
				self.dirScale = 1
			elif dis < self.attackMinDis:
				self.dirScale = -1
			else:
				transiteStateS.emit(AttackState.new(self.stateOwner))
		
class AttackState extends State:
	func attack():
		var attackFunc: Callable = self.stateOwner.get("attack")
		if attackFunc:
			attackFunc.call()
		
	func enter():
		if not is_instance_valid(self.stateOwner):
			transiteStateS.emit(MoveState.new(self.stateOwner))
			
		await attack()
		
		transiteStateS.emit(WanderState.new(self.stateOwner))

class WanderState extends State:
	var dir: Vector2
	
	func enter():
		var timer = GameInfo.allocate_timer(1.0)
		dir = Vector2.from_angle(randf() * TAU)
		timer.timeout.connect(switch)
		
	func switch():
		transiteStateS.emit(MoveState.new(self.stateOwner))
		
	func physics_process(delta):
		if self.stateOwner.target:
			self.stateOwner.velocity = dir * self.stateOwner.attr.speed
		else:
			self.stateOwner.velocity = Vector2.ZERO
		self.stateOwner.move_and_slide()
	
func _init():
	super._init()
	self.attr.maxHP = 150
	self.state.HP = 150
	
func set_target(t: Node2D):
	self.target = t
	
func _ready():
	self.transite_to_state(MoveState.new(self))
	
func attack():
	if canAttack:
		for i in range(5):
			var waterball = waterballScene.instantiate()
			GameInfo.add_node(waterball)
			var damage = Damage.new(15)
			var projAng = (target.global_position - global_position).angle()
			var projVelocity = Vector2.from_angle(projAng + randf_range(-0.5, 0.5))
			var overideDict = {
				"global_position": self.global_position,
				"damage": damage,
				"targetGroup": "player",
				"traj_func": func(delta, projectile: Node2D):
					projectile.position += 200 * delta * projVelocity
			}
			waterball.override(overideDict)
			await get_tree().create_timer(0.03).timeout
			
		self.canAttack = false
		var timer = GameInfo.allocate_timer(self.attackCoolDownInterval)
		timer.timeout.connect(set_attack_avaiable)
		
func set_attack_avaiable():
	self.canAttack = true
		
