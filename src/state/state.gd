extends Node

enum GameMode {
	Pause,
	Build,
	Play,
}

var game_mode: GameMode = GameMode.Play

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
	
