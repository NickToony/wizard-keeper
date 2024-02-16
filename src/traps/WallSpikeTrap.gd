extends Node3D

@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

var blades: Array[Node3D]
var currentScale = 0
var baseScale = 0
var maxScale = 1
var lunging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$DamageArea.trap_ticked.connect(_on_tick)
	for blade in $spiketrap.find_children("blade_*"):
		blades.append(blade)
		baseScale = blade.scale
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func _on_tick():
	lunging = true
	audio.play()
