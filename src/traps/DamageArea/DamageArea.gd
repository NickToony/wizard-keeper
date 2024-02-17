extends Area3D

signal trap_ticked
signal trap_ticked_effective

@export var onlyFireIfTargets = false
var targets = []
var tick = 100
var trap

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	pass
	
func setup():
	tick = trap.cooldown * 60
	
func _process(_delta):
	tick -= _delta * 100
	if tick < 0 && (!onlyFireIfTargets || targets.size() > 0):
		tick = trap.cooldown * 60
		for target in targets:
			target.damaged(trap.damage)
		emit_signal("trap_ticked")
		if targets.size() > 0:
			emit_signal("trap_ticked_effective")

func _on_body_entered(body: Node3D):
	if body.is_in_group('enemies'):
		targets.append(body)

func _on_body_exited(body: Node3D):
	if body.is_in_group('enemies'):
		targets.erase(body)
