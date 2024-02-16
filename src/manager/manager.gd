#@tool
extends Node

@onready var enemies = $"../Enemies"

@export var stages: Array[LevelPart] = [] 

var toSpawn = []
var step = 0
var stageStep = 0

func _ready():

	pass
	
func _physics_process(delta):
	if State.game_mode == State.GameMode.Play:
		if stageStep < toSpawn.size():
			spawnEnemy()
			return
		
		if get_tree().get_nodes_in_group("enemies").size() > 0:
			return
			
		State.game_mode = State.GameMode.Build
		toSpawn = []
	
	if State.game_mode == State.GameMode.Build:
		if toSpawn.size() > 0:
			return
		if step >= stages.size():
			return
		
		var stage = stages[step]
		toSpawn = stage.monsters
		stageStep = 0
		
		step += 1

func spawnEnemy():
	for spawn in get_tree().get_nodes_in_group("spawns"):
		if !spawn.isOccupied():
			var mob
			match toSpawn[0]:
				LevelPart.Spawnables.Goblin:
					mob = load("res://src/entities/enemies/Enemy.tscn")
			
			if mob:
				var instance = mob.instantiate()
				instance.position = spawn.position
				enemies.add_child(instance)
			
			stageStep += 1
			
			break
