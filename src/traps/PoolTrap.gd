extends Node3D

@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$DamageArea.trap_ticked_effective.connect(_on_tick_with_hit)
	pass

func _on_tick_with_hit():
	audio.play()
