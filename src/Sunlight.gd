extends DirectionalLight3D

func _process(delta):
	if shadow_enabled != State.lights:
		shadow_enabled = State.lights
	pass
