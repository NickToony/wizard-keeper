extends Node


var PROJECTILE_BASIC = preload("res://src/attacks/projectile.tscn")

var UNIT_GOBLIN = preload("res://src/entities/enemies/Enemy.tscn")

enum GameMode {
	Pause,
	Build,
	Play,
}

var game_mode: GameMode = GameMode.Play
var current_trap = "pool"
var modeLast = game_mode
var music = false
var lives = 20

var availableWeapons = ["staff", "staff_fire", "staff_flame_thrower", "implosion"]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	var pressBuild = Input.is_action_just_pressed("build_mode")
	var pressPause = Input.is_action_just_pressed("pause_mode")
	
	var gameModeChanged = false
	if pressPause:
		if game_mode == GameMode.Pause:
			game_mode = modeLast
		else:
			modeLast = game_mode
			game_mode = GameMode.Pause
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
			current_trap = "pool"
		if Input.is_action_just_pressed("bar2"):
			current_trap = "spikes"
