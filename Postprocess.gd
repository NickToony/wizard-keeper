extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().size_changed.connect(resize)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func resize():
	size = DisplayServer.window_get_size()
