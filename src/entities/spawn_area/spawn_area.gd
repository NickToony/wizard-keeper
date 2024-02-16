extends Area3D

var inside = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	pass
	
func _on_body_entered(body):
	inside.append(body)
	
func _on_body_exited(body):
	inside.erase(body)

func isOccupied():
	return inside.size() > 0
