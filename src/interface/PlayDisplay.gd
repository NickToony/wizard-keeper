extends Control

func _process(delta):
	visible = State.game_mode == State.GameMode.Play
