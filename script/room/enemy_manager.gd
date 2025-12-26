class_name EnemyManager

var enemyGenerationInfo: Array

var enemyList: Array
var currentWave: int
var totalWave: int
var currentRoom: Node2D

signal enemyClearedS

func _init(a: Array):
	enemyGenerationInfo = a
	totalWave = len(enemyGenerationInfo)
	currentWave = 0
	
func set_enemy():
	if currentWave >= totalWave:
		return
	if currentRoom == null:
		push_warning("You should set room first!")
	
	var enemies = enemyGenerationInfo[currentWave]
	for enemy in enemies:
		var e: BaseEnemy = GameInfo.allocate_enemy(enemy["name"])
		currentRoom.add_child(e)
		e.position = enemy["position"]
		e.deathS.connect(_on_enemy_death)
		enemyList.append(e)
		
		if e.isBoss:
			currentRoom.set_boss(e)
	
	currentWave += 1

func _on_enemy_death(e: BaseEnemy):
	enemyList.erase(e)
	if len(enemyList) == 0 and currentWave == totalWave:
		enemyClearedS.emit()
	elif len(enemyList) == 0:
		set_enemy()
		activate_enemies()

func activate_enemies():
	for enemy in enemyList:
		enemy.target = currentRoom.player
		enemy.activate()
