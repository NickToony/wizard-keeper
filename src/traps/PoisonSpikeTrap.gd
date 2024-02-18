extends "res://src/traps/BaseTrap.gd"

var blades: Array[Node3D]
var currentScale = 0
var baseScale = 0
var maxScale = 1
var lunging = false


func _ready():
	super()
	for blade in $poisonspike.find_children("blade_*"):
		blades.append(blade)
		baseScale = blade.scale
	pass


func _process(delta):
	if lunging:
		currentScale += 10 * delta
		if currentScale > 1:
			lunging = false
	else:
		if currentScale > 0:
			currentScale -= 2 * delta
	for blade in blades:
		blade.scale = Vector3(baseScale.x, baseScale.y + currentScale, baseScale.z)
	pass

func _on_tick_with_hit():
	super()
	lunging = true
	audio.play()
