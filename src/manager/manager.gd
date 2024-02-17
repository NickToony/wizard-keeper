#@tool
extends Node

@onready var enemies = $"../Enemies"

@export var levelName: String = "level1"

var enemyScene = preload("res://src/entities/enemies/Enemy.tscn")

var toSpawn = []
var cutscenes = []
var step = 0
var stageStep = 0
var cutsceneIndex = 0
var attacksceneIndex = 0
var attackscenes = []
var shop = false
@onready var level = Levels.levels[levelName]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
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
		
		if stageStep < toSpawn.size():
			spawnEnemy()
			return
		
		if get_tree().get_nodes_in_group("enemies").size() > 0:
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
			# Game over
			State.cutsceneContent = "I've held them back for now. Time to check the other dungeons."
			State.cutsceneActor = "Wizard"
			State.cutscenePosition = null
			State.gameEnd = true
			State.game_mode = State.GameMode.Cutscene
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
		if stage.has('gold'):
			State.gold += stage.gold
		shop = false
		if stage.has('shop') && stage.shop:
			shop = true
		
		if stage.has('weapons') && stage.weapons.size():
			State.setWeapons(stage.weapons[0], stage.weapons[1])
		if stage.has('traps') && stage.traps.size():
			State.setTraps(stage.traps)
		
		step += 1

func spawnEnemy():
	for spawn in get_tree().get_nodes_in_group("spawns"):
		if !spawn.isOccupied():
			var mob
			match toSpawn[stageStep]:
				Levels.Spawnable.Goblin:
					mob = Enemies.Definitions.Goblin
				Levels.Spawnable.Zombie:
					mob = Enemies.Definitions.Zombie
				Levels.Spawnable.Demon:
					mob = Enemies.Definitions.Demon
			
			if mob:
				var instance = enemyScene.instantiate()
				instance.position = spawn.position
				instance.definition = mob
				enemies.add_child(instance)
			
			stageStep += 1
			
			break
