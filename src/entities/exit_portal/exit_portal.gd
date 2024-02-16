extends Node3D


func _on_area_3d_body_entered(body):
	body.queue_free()
	State.lives -= body.definition.lives
	pass
