extends CharacterBody3D


@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var modelAnimation: AnimationPlayer
@onready var model: Node3D
@onready var goblin = $Goblin

@export var fall_acceleration = 75

var damageLabelScene = preload("res://src/entities/damagelabel/DamageText.tscn")

var target
var health = 100
var maxHealth = health
var definition
var respawn = false

func _ready() -> void:
	health = definition.health
	maxHealth = health
	model = load(definition.mesh).instantiate()
	modelAnimation = model.get_node("AnimationPlayer")
	navigation_agent.max_speed = definition.speed
	model.position = goblin.position
	model.scale = Vector3(definition.scale, definition.scale, definition.scale)
	respawn = definition.respawn
	remove_child(goblin)
	add_child(model)
	
	target = get_tree().get_nodes_in_group("players")[0]
	
	var exit = get_tree().get_nodes_in_group("exit")[0]
	navigation_agent.set_target_position(exit.global_position)
	
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	modelAnimation.animation_finished.connect(_on_animation_finished)
	modelAnimation.get_animation("Death").loop_mode = Animation.LOOP_NONE
	modelAnimation.get_animation("Attack").loop_mode = Animation.LOOP_NONE
	
func _on_animation_finished(animation: String):
	modelAnimation.speed_scale = 1
	match animation:
		"Death":
			if !respawn:
				State.gold += definition.gold
				queue_free()
			else:
				$ResSound.play()
				respawn = false
				health = maxHealth
		"Attack":
			if is_instance_valid(target):
				target.health -= definition.damage

func _process(delta):
	if health <= 0:
		if !modelAnimation.current_animation == "Death":
			modelAnimation.play("Death")
			$DeathSound.play()
		return
	
	# func set_movement_target(movement_target: Vector3):
	if target && is_instance_valid(target):
		#navigation_agent.set_target_position(target.global_position)
	
		if position.distance_to(target.global_position) < 1:
			modelAnimation.play("Attack")
			modelAnimation.speed_scale = definition.attackspeed
			var dir =  global_position.direction_to(target.global_position)
			model.rotation.y = lerp_angle(model.rotation.y, atan2(-dir.x, -dir.z) + PI, 0.2)
			return
	
	var speed = velocity.length()
	if speed > 1:
		modelAnimation.play("Run")
		model.rotation.y = lerp_angle(model.rotation.y, atan2(-velocity.x, -velocity.z) + PI, 0.2)
	elif speed > 0.1:
		modelAnimation.play("Walk")
		model.rotation.y = lerp_angle(model.rotation.y, atan2(-velocity.x, -velocity.z) + PI, 0.2)
	else:
		modelAnimation.play("Idle")

func _physics_process(delta):
	var targetVelocity = Vector3.ZERO;
	if health <= 0 || modelAnimation.current_animation == 'Attack':
		pass
	elif !navigation_agent.is_navigation_finished():
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		targetVelocity = global_position.direction_to(next_path_position) * definition.speed

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
