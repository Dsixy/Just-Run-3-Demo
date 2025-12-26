extends BaseEnemy

@onready var rushHitbox = $Hitbox
@onready var rushShape = $Hitbox/CollisionShape2D.shape
const songberryTreeScene = preload("res://scene/enemy/songberry_tree.tscn")
const pineconeScene = preload("res://scene/item/projectile/pinecone.tscn")
var treeList: Array
var isHaste: bool = false

class MoveState extends State:
	var attackMinDis: int = 300
	var attackMaxDis: int = 800
	var dirScale: int = 1
		
	func physics_process(delta):
		if self.stateOwner.target:
			var dir = self.get_target_relative_position().normalized()
			self.stateOwner.velocity = dir * self.stateOwner.attrManager.speed.final_value() * self.dirScale
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
				transiteStateS.emit(ShootState.new(self.stateOwner))

class ShootState extends State:
	func _init(o: Node2D):
		self.stateOwner = o
		self.readyTime = 1.0
		self.endTime = 1.0
		
	func enter():
		await GameInfo.allocate_timer(self.readyTime).timeout
		await attack()
		await GameInfo.allocate_timer(self.endTime).timeout
		transiteStateS.emit(WanderState.new(self.stateOwner))
		
	func attack():
		var attackFunc: Callable = self.stateOwner.get("shoot")
		if attackFunc:
			attackFunc.call()
	
class PlantState extends State:
	func enter():
		attack()
		transiteStateS.emit(WanderState.new(self.stateOwner))
		
	func attack():
		var attackFunc: Callable = self.stateOwner.get("plant")
		if attackFunc:
			attackFunc.call()
		
class RushState extends State:
	var rushScale: float
	var restTime: float
	func _init(o: Node2D):
		self.stateOwner = o
		self.readyTime = 0.6
		self.endTime = 0.6
		self.rushScale = 3.0 if self.stateOwner.isHaste else 2.0
		self.restTime = 0.5 if self.stateOwner.isHaste else 0.8
	
	func enter():
		self.stateOwner.rushHitbox.monitoring = true
		var rushTime = 4 if self.stateOwner.isHaste else 2
		await GameInfo.allocate_timer(self.readyTime).timeout
		for i in range(rushTime):
			rush()
			self.stateOwner.velocity = Vector2.ZERO
			await GameInfo.allocate_timer(self.restTime).timeout
		await GameInfo.allocate_timer(self.endTime).timeout
		transiteStateS.emit(WanderState.new(self.stateOwner))
	
	func exit():
		self.stateOwner.rushHitbox.monitoring = false
		
	func rush():
		if self.stateOwner.target:
			var dir = self.get_target_relative_position().normalized()
			self.stateOwner.velocity = dir * self.stateOwner.attrManager.speed.final_value() * self.rushScale
		else:
			self.stateOwner.velocity = Vector2.ZERO
			
	func physics_process(delta):
		self.stateOwner.move_and_slide()
	
class WanderState extends State:
	var dir: Vector2
	
	func enter():
		var timer = GameInfo.allocate_timer(1.0)
		dir = Vector2.from_angle(randf() * TAU)
		timer.timeout.connect(switch)
		
	func switch():
		var avaiableState = [ShootState, RushState]
		if len(self.stateOwner.treeList) == 0:
			avaiableState.append(PlantState)
		var nextState = avaiableState.pick_random()
		transiteStateS.emit(nextState.new(self.stateOwner))
		
	func physics_process(delta):
		if self.stateOwner.target:
			self.stateOwner.velocity = dir * self.stateOwner.attrManager.speed.final_value()
		else:
			self.stateOwner.velocity = Vector2.ZERO
		self.stateOwner.move_and_slide()
	
func _init():
	super._init()
	self.attrManager = AttrManager.new({
		"maxHP": 3000
	})
	self.isBoss = true
	
func set_target(t: Node2D):
	self.target = t
	
func _ready():
	self.transite_to_state(MoveState.new(self))
	
func shoot():
	var waveNum = 4 if self.isHaste else 2
	var bulletNum = 8 if self.isHaste else 5
	for c in range(waveNum):
		for i in range(bulletNum):
			var pinecone = pineconeScene.instantiate()
			GameInfo.add_node(pinecone)
			var damage = Damage.new(20, 0, 0, 1, "Piercing")
			var projAng = (target.global_position - global_position).angle()
			var projVelocity = Vector2.from_angle(projAng + (i-4) * 0.2)
			var overideDict = {
				"global_position": self.global_position,
				"damage": damage,
				"targetGroup": "player",
				"traj_func": func(delta, projectile: Node2D):
					projectile.position += 500 * delta * projVelocity
			}
			pinecone.override(overideDict)
		await get_tree().create_timer(0.3).timeout
		
func plant():
	var room = get_parent()
	for i in range(3):
		var songberryTree = songberryTreeScene.instantiate()
		room.add_child(songberryTree)
		treeList.append(songberryTree)
		songberryTree.position = Vector2(randi_range(200, 1200), randi_range(200, 1200))
		songberryTree.set_target_and_boss(target, self)
		songberryTree.deathS.connect(_on_songberry_tree_disappear)
		
func take_damage(damage: Damage):
	damage = self.buffManager.process_damage(damage)
	damage = self.damageScaleManager.process_damage(damage)
	var final_damage_amount = damage.finalDamage
	FightInfoManager.show_damage_label(damage, global_position + Vector2.UP * 50)
	self.attrManager.set_state_value("HP", -final_damage_amount)
	HPChangeS.emit()
	
	if self.attrManager.HP <= 0:
		self.death()
	elif self.attrManager.HP < self.attrManager.maxHP.final_value() * 0.3 and not self.isHaste:
		self.isHaste = true
		
func _on_songberry_tree_disappear(node: BaseEnemy):
	treeList.erase(node)

func _on_hitbox_area_entered(area):
	var damage = Damage.new(30, 0, 0, 1, "Blunt")
	if area.is_in_group(self.targetGroup):
		var target = area.get_parent()
		target.take_damage(damage.copy())

func _on_hitbox_body_entered(body):
	if not body.is_in_group("wall"):
		return

	var room = body.get_parent()
	var damage = Damage.new(30, 0, 0, 1, "Blunt")
	room.take_damage_by_rect2(Rect2(rushHitbox.global_position - rushShape.size / 2, rushShape.size), damage)
