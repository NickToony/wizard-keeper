extends Node


var PROJECTILE_BASIC = preload("res://src/attacks/projectile.tscn")

var TRAP_POOL = preload("res://src/traps/PoolTrap.tscn")
var TRAP_WALL_SPIKE = preload("res://src/traps/WallSpikeTrap.tscn")

var UNIT_GOBLIN = preload("res://src/entities/enemies/Enemy.tscn")

enum GameMode {
	Pause,
	Build,
	Play,
}

var game_mode: GameMode = GameMode.Play
var current_trap = TRAP_POOL

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	var pressBuild = Input.is_action_just_pressed("build_mode")
	var pressPause = Input.is_action_just_pressed("pause_mode")
	
	var gameModeChanged = false
	if pressPause:
		game_mode = GameMode.Play if game_mode == GameMode.Pause else GameMode.Pause
		gameModeChanged = true
	elif game_mode != GameMode.Pause && pressBuild:
		game_mode = GameMode.Build if game_mode == GameMode.Play else GameMode.Play
		gameModeChanged = true
		
	if gameModeChanged:
		get_tree().paused = game_mode != GameMode.Play
		for player in get_tree().get_nodes_in_group("players"):
			player.process_mode = Node.PROCESS_MODE_ALWAYS if game_mode == GameMode.Build else Node.PROCESS_MODE_INHERIT
	
	if game_mode == GameMode.Build:
		if Input.is_action_just_pressed("bar1"):
			current_trap = TRAP_POOL
		if Input.is_action_just_pressed("bar2"):
			current_trap = TRAP_WALL_SPIKE
		if Input.is_action_just_pressed("bar3"):
			current_trap = UNIT_GOBLIN;
