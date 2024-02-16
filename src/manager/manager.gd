#@tool
extends Node

@onready var enemies = $"../Enemies"

@export var levelName: String = "level1"

@onready var calmMusic = $CalmMusic
@onready var actionMusic = $ActionMusic
@onready var animationPlayer = $AnimationPlayer

var enemyScene = preload("res://src/entities/enemies/Enemy.tscn")

var toSpawn = []
var step = 0
var stageStep = 0
var level = Levels.levels[levelName]

func _ready():
	pass
	
func _physics_process(delta):
	if State.game_mode == State.GameMode.Play:
		if !actionMusic.playing:
			crossfade_to()
		
		if stageStep < toSpawn.size():
			spawnEnemy()
			return
		
		if get_tree().get_nodes_in_group("enemies").size() > 0:
			return
			
		State.game_mode = State.GameMode.Wait
		toSpawn = []
	
	if State.game_mode == State.GameMode.Wait:
		if !calmMusic.playing:
			crossfade_to()
		
		if toSpawn.size() > 0:
			return
		if step >= level.size():
			return
		
		var stage = level[step]
		toSpawn = []
		State.nextWave = ""
		for enemies in stage.enemies:
			State.nextWave = State.nextWave + str(enemies.count) + " " + Levels.Spawnable.keys()[enemies.type] + "s   "
			for i in range(enemies.count):
				toSpawn.append(enemies.type)
		toSpawn.shuffle()
		stageStep = 0
		
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


# crossfades to a new audio stream
func crossfade_to() -> void:
	if !State.music:
		return
	
	# If both tracks are playing, we're calling the function in the middle of a fade.
	# We return early to avoid jumps in the sound.
	if calmMusic.playing and actionMusic.playing:
		return

	# The `playing` property of the stream players tells us which track is active. 
	# If it's track two, we fade to track one, and vice-versa.
	if actionMusic.playing:
		#calmMusic.stream = audio_stream
		calmMusic.play()
		animationPlayer.play("FadeToCalm")
	else:
		#actionMusic.stream = audio_stream
		actionMusic.play()
		animationPlayer.play("FadeToAction")
