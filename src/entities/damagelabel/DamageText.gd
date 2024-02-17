extends Label3D

var color: Color
func _ready():
	if color:
		modulate = color

func _process(delta):
	modulate.a -= 1 * delta
	position.y += 0.5 * delta
	if modulate.a < 0:
		queue_free()
	pass
