extends Button

func _process(delta):
	text = "Enable Shadows" if !State.lights else "Disable Shadows"

func _on_pressed():
	State.lights = !State.lights
	pass
