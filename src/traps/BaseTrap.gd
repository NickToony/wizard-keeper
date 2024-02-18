extends Node3D

@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var damage_area = $DamageArea

@export var play_sound = true

var trap

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_area.trap_ticked_effective.connect(_on_tick_with_hit)
	damage_area.trap = trap
	damage_area.setup()
	pass

func _on_tick_with_hit():
	if play_sound:
		audio.play()
