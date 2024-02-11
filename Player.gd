extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

@onready var modelAnimation: AnimationPlayer = $Wizard/AnimationPlayer

var target_velocity = Vector3.ZERO


func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x -= 1
	if Input.is_action_pressed("move_left"):
		direction.x += 1
	if Input.is_action_pressed("move_down"):
		direction.z -= 1
	if Input.is_action_pressed("move_up"):
		direction.z += 1

	if direction != Vector3.ZERO:
		direction = direction.normalized().rotated(Vector3.DOWN, PI/4)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
	if velocity != Vector3.ZERO:
		modelAnimation.play("Run")
	else:
		modelAnimation.play("Idle")
	
	var spaceState = get_world_3d().direct_space_state
	var camera: Camera3D = $Camera3D
	var from = camera.project_ray_origin(camera.get_viewport().get_mouse_position())
	var to = from + camera.project_ray_normal(camera.get_viewport().get_mouse_position()) * 100
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var intersection = spaceState.intersect_ray(query)
		
	if !intersection.is_empty():
		var lookPos = intersection.position
		var wizard: Node3D = $Wizard
		lookPos.y = wizard.global_position.y
		wizard.look_at(lookPos, Vector3(0, 1, 0), true)
