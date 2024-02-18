extends Button

func _process(delta):
	text = "Enable Outline Shader" if !State.shader else "Disable Outline Shader"

func _on_pressed():
	State.shader = !State.shader
	pass
