extends CharacterBody3D


@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var modelAnimation: AnimationPlayer = $Goblin/AnimationPlayer
@onready var goblin: Node3D = $Goblin

@export var movement_speed: float = 4.0
@export var fall_acceleration = 75

var damageLabelScene = preload("res://src/entities/damagelabel/DamageText.tscn")

var target
var health = 100
var damage = 10

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	modelAnimation.animation_finished.connect(_on_animation_finished)
	modelAnimation.get_animation("Death").loop_mode = Animation.LOOP_NONE
	modelAnimation.get_animation("Attack").loop_mode = Animation.LOOP_NONE
	
	navigation_agent.max_speed = movement_speed
	
	target = get_tree().get_nodes_in_group("players")[0]
	
	var exit = get_tree().get_nodes_in_group("exit")[0]
	navigation_agent.set_target_position(exit.global_position)
	
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
		#navigation_agent.set_target_position(target.global_position)
	
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
	var targetVelocity = Vector3.ZERO;
	if health <= 0 || modelAnimation.current_animation == 'Attack':
		pass
	elif !navigation_agent.is_navigation_finished():
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		targetVelocity = global_position.direction_to(next_path_position) * movement_speed

	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(targetVelocity)
	else:
		_on_velocity_computed(targetVelocity)

func _on_velocity_computed(safe_velocity: Vector3):
	if health <= 0:
		return
	
	velocity = safe_velocity
	
		# Vertical Velocity
	if !navigation_agent.is_navigation_finished() && !is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y = velocity.y - (fall_acceleration)
	
	move_and_slide()

func damaged(amount):
	var damageLabel = damageLabelScene.instantiate()
	damageLabel.text = str(amount)
	damageLabel.position = global_position
	get_parent().add_child(damageLabel)
