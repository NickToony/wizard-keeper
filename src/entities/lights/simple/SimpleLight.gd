@tool
extends OmniLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = !Engine.is_editor_hint()

func _process(delta):
	if shadow_enabled != State.lights:
		shadow_enabled = State.lights
