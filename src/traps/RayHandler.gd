extends "res://src/traps/BaseTrap.gd"

var rays: Array[Node3D]
var currentScale = 0
var baseScale = 0
var maxScale = 1
var lunging = false

@export var regex = "blade_*"
@export var lungeSpeed = 10
@export var retractSpeed = 2
@export var model: Node
@export var startHidden = false
@export var negateX = false

var from: Vector3
var to: Vector3
var basePosZ: float


func _ready():
	super()
	for ray in model.find_children(regex):
		rays.append(ray)
		baseScale = ray.scale
		basePosZ = ray.position.z
	if !startHidden:
		from = baseScale
		to = baseScale + Vector3(0,1,0)
	else:
		from = baseScale
		to = baseScale + Vector3(0,1,0)
		from.y = 0
		for ray in rays:
			ray.scale = from
	pass


func _process(delta):
	if lunging:
		currentScale += lungeSpeed * delta
		if currentScale > 1:
			lunging = false
	else:
		if currentScale > 0:
			currentScale -= retractSpeed * delta
	for ray in rays:
		ray.visible = currentScale > 0
		ray.scale = from.lerp(to, currentScale)
		ray.position.z = basePosZ * currentScale
	pass

func _on_tick_with_hit():
	super()
	lunging = true
	audio.play()
