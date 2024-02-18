extends Node

@onready var enemies = $"../Enemies"

var enemyScene = preload("res://src/entities/enemies/Enemy.tscn")

var toSpawn = []
var cutscenes = []
var step = 0
var stageStep = 0
var cutsceneIndex = 0
var attacksceneIndex = 0
var attackscenes = []
var shop = false
var pauseSpawning = false
var level

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	level = Levels.levels[get_parent().level_name].stages
	pass
	
func _physics_process(delta):
	if State.lives < 0:
		# Game over
		State.cutsceneContent = "Too many have escaped, the towns are overwhelmed. I have failed my duty.."
		State.cutsceneActor = "Wizard"
		State.cutscenePosition = null
		State.gameEnd = true
		State.game_mode = State.GameMode.Cutscene
		return;
	
	if State.game_mode == State.GameMode.Play:
		if stageStep > 4 && attacksceneIndex < attackscenes.size():
			State.cutsceneContent = attackscenes[attacksceneIndex].text
			State.cutsceneActor = attackscenes[attacksceneIndex].actor
			State.cutscenePosition = attackscenes[attacksceneIndex].target
			State.cutscenePlay = true
			attacksceneIndex += 1
			State.game_mode = State.GameMode.Cutscene
			return
		
		var enemyCount = get_tree().get_nodes_in_group("enemies").size() 
		if stageStep < toSpawn.size():
			if !pauseSpawning:
				spawnEnemy()
				if enemyCount > 40:
					pauseSpawning = true
			else:
				if enemyCount < 5:
					pauseSpawning = false
			return
		
		if enemyCount > 0:
			return
			
		State.game_mode = State.GameMode.Wait
		toSpawn = []
	
	if State.game_mode == State.GameMode.Wait:
		if cutsceneIndex < cutscenes.size() && !State.shop:
			State.cutsceneContent = cutscenes[cutsceneIndex].text
			State.cutsceneActor = cutscenes[cutsceneIndex].actor
			State.cutscenePosition = cutscenes[cutsceneIndex].target
			cutsceneIndex += 1
			State.game_mode = State.GameMode.Cutscene
			State.cutscenePlay = false
			State.game_mode = State.GameMode.Cutscene
			return
		
		if shop:
			State.shop = true
			State.rerolls = 0
			shop = false
			return
		
		if toSpawn.size() > 0:
			return
		if step >= level.size():
			if !State.endless || step > 10:
				# Game over
				State.cutsceneContent = "I've held them back for now. Time to check the other dungeons."
				State.cutsceneActor = "Wizard"
				State.cutscenePosition = null
				State.gameEnd = true
				State.game_mode = State.GameMode.Cutscene
			else:
				endlessWave()
			return
		
		var stage = level[step]
		toSpawn = []
		State.nextWave = ""
		for enemies in stage.enemies:
			State.nextWave = State.nextWave + str(enemies.count) + " " + Levels.Spawnable.keys()[enemies.type] + "s   "
			for i in range(enemies.count):
				toSpawn.append(enemies.type)
		toSpawn.shuffle()
		cutscenes = stage.cutscenes if stage.has('cutscenes') else []
		attackscenes = stage.attackscenes if stage.has('attackscenes') else []
		cutsceneIndex = 0
		attacksceneIndex = 0
		stageStep = 0
		pauseSpawning = false
		if stage.has('gold'):
			State.gold += stage.gold
		shop = false
		if stage.has('shop') && stage.shop:
			shop = true
		
		if stage.has('weapons') && stage.weapons.size():
			State.setWeapons(stage.weapons[0], stage.weapons[1])
		if stage.has('traps') && stage.traps.size():
			State.setTraps(stage.traps)
		if stage.has('difficulty'):
			State.difficulty = stage.difficulty
		if stage.has('endless'):
			State.endless = true
		
		step += 1
		
func endlessWave():
	State.difficulty += 0.1
	State.nextWave = ''
	
	var counts = {
		Levels.Spawnable.Goblin: 0,
		Levels.Spawnable.Zombie: 0,
		Levels.Spawnable.Demon: 0,
		Levels.Spawnable.Skeleton: 0,
		Levels.Spawnable.HeavySkeleton: 0,
		Levels.Spawnable.Giant: 0,
	}
	
	var maxCost = State.difficulty * (step + 1) * 15
	var currentCost = 0
	var options = []
	for i in range(100): options.append(Levels.Spawnable.Goblin)
	for i in range(40): options.append(Levels.Spawnable.Zombie)
	for i in range(10): options.append(Levels.Spawnable.Demon)
	if step >= 3:
		for i in range(40): options.append(Levels.Spawnable.Skeleton)
	if step >= 4:
		for i in range(30): options.append(Levels.Spawnable.HeavySkeleton)
	if step >= 5:
		for i in range(5): options.append(Levels.Spawnable.Giant)
	while currentCost < maxCost:
		var mob = options.pick_random()
		
		counts[mob] += 1
		toSpawn.append(mob)
		currentCost += spawnableToDefinition(mob).value
	
	for key in counts.keys():
		var val = counts[key]
		State.nextWave = State.nextWave + str(val) + " " + Levels.Spawnable.keys()[key] + "s   "
	
	step += 1
	stageStep = 0
	shop = true
	pauseSpawning = false

func spawnEnemy():
	for spawn in get_tree().get_nodes_in_group("spawns"):
		if !spawn.isOccupied():
			var mob = spawnableToDefinition(toSpawn[stageStep])
			
			if mob:
				var instance = enemyScene.instantiate()
				instance.position = spawn.position
				instance.definition = mob
				enemies.add_child(instance)
			
			stageStep += 1
			
			break

func spawnableToDefinition(spawnable):
	match spawnable:
		Levels.Spawnable.Goblin:
			return Enemies.Definitions.Goblin
		Levels.Spawnable.Zombie:
			return Enemies.Definitions.Zombie
		Levels.Spawnable.Demon:
			return Enemies.Definitions.Demon
		Levels.Spawnable.Skeleton:
			return Enemies.Definitions.Skeleton
		Levels.Spawnable.HeavySkeleton:
			return Enemies.Definitions.HeavySkeleton
		Levels.Spawnable.Giant:
			return Enemies.Definitions.Giant
