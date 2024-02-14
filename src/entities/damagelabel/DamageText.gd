extends Label3D

func _process(delta):
	modulate.a -= 1 * delta
	position.y += 0.5 * delta
	if modulate.a < 0:
		queue_free()
	pass
