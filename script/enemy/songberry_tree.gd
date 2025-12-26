extends BaseEnemy

const pineconeScene = preload("res://scene/item/projectile/pinecone.tscn")
var boss: BaseEnemy
	
class IdleState extends State:
	func enter():
		await GameInfo.allocate_timer(5.0).timeout
		transiteStateS.emit(AttackState.new(self.stateOwner))
		
class AttackState extends State:
	func attack():
		var attackFunc: Callable
		if not is_instance_valid(self.stateOwner):
			return
			
		if self.stateOwner.boss.isHaste: 
			attackFunc = self.stateOwner.get("attack")
		else:
			attackFunc = self.stateOwner.get("heal_owner")
		if attackFunc:
			attackFunc.call()
		
	func enter():
		if not is_instance_valid(self.stateOwner):
			transiteStateS.emit(IdleState.new(self.stateOwner))
			
		await attack()
		transiteStateS.emit(IdleState.new(self.stateOwner))
	
func _init():
	super._init()
	self.attrManager = AttrManager.new({
		"maxHP": 300
	})
	
func set_target(t: Node2D):
	self.target = t
	
func _ready():
	self.transite_to_state(IdleState.new(self))
	
func heal_owner():
	if is_instance_valid(self.boss):
		self.boss.heal(125)
	
func attack():
	for i in range(8):
		var pinecone = pineconeScene.instantiate()
		GameInfo.add_node(pinecone)
		var damage = Damage.new(10, 0, 0, 1, "Piercing")
		var projAng = (target.global_position - global_position).angle()
		var projVelocity = Vector2.from_angle(projAng + (i-4) * 0.36)
		var overideDict = {
			"global_position": self.global_position,
			"damage": damage,
			"targetGroup": "player",
			"traj_func": func(delta, projectile: Node2D):
				projectile.position += 600 * delta * projVelocity
		}
		pinecone.override(overideDict)

func set_target_and_boss(trt: BaseCharacter, source: BaseEnemy):
	target = trt
	boss = source
	boss.deathS.connect(death)
