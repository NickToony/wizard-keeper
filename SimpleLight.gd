@tool
extends OmniLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = !Engine.is_editor_hint()
