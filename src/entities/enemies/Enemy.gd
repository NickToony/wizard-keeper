# extends CharacterBody3D


# const SPEED = 5.0
# const JUMP_VELOCITY = 4.5

# # Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# func _physics_process(delta):
# 	# Add the gravity.
# 	if not is_on_floor():
# 		velocity.y -= gravity * delta

# 	# Handle jump.
# 	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
# 		velocity.y = JUMP_VELOCITY

# 	# Get the input direction and handle the movement/deceleration.
# 	# As good practice, you should replace UI actions with custom gameplay actions.
# 	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
# 	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
# 	if direction:
# 		velocity.x = direction.x * SPEED
# 		velocity.z = direction.z * SPEED
# 	else:
# 		velocity.x = move_toward(velocity.x, 0, SPEED)
# 		velocity.z = move_toward(velocity.z, 0, SPEED)

# 	move_and_slide()



extends CharacterBody3D

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var modelAnimation: AnimationPlayer = $Goblin/AnimationPlayer
@onready var goblin: Node3D = $Goblin

var target
var health = 100
var damage = 10

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	modelAnimation.animation_finished.connect(_on_animation_finished)
	modelAnimation.get_animation("Death").loop_mode = Animation.LOOP_NONE
	modelAnimation.get_animation("Attack").loop_mode = Animation.LOOP_NONE
	
	target = get_tree().get_nodes_in_group("players")[0]
	
func _on_animation_finished(animation: String):
	match animation:
		"Death":
			queue_free()
		"Attack":
			if is_instance_valid(target):
				target.health -= damage

func _process(delta):
	if health <= 0:
		modelAnimation.play("Death")
		return
	
	# func set_movement_target(movement_target: Vector3):
	if target && is_instance_valid(target):
		navigation_agent.set_target_position(target.global_position)
	
		if position.distance_to(target.global_position) < 1:
			modelAnimation.play("Attack")
			var dir =  global_position.direction_to(target.global_position)
			goblin.rotation.y = lerp_angle(goblin.rotation.y, atan2(-dir.x, -dir.z) + PI, 0.2)
			return
	
	var speed = velocity.length()
	if speed > 1:
		modelAnimation.play("Run")
		goblin.rotation.y = lerp_angle(goblin.rotation.y, atan2(-velocity.x, -velocity.z) + PI, 0.2)
	elif speed > 0.1:
		modelAnimation.play("Walk")
		goblin.rotation.y = lerp_angle(goblin.rotation.y, atan2(-velocity.x, -velocity.z) + PI, 0.2)
	else:
		modelAnimation.play("Idle")

func _physics_process(delta):
	return
	var targetVelocity = Vector3.ZERO;
	if health <= 0:
		pass;
	elif !navigation_agent.is_navigation_finished():
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		targetVelocity = global_position.direction_to(next_path_position) * movement_speed

	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(targetVelocity)
	else:
		_on_velocity_computed(targetVelocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
