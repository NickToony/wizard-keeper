extends CharacterBody3D


@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var modelAnimation: AnimationPlayer
@onready var model: Node3D
@onready var goblin = $Goblin
@onready var status_text = $StatusText

@export var fall_acceleration = 75

var damageLabelScene = preload("res://src/entities/damagelabel/DamageText.tscn")

var target
var health = 100
var maxHealth = health
var definition
var respawn = false
		
var stunTime = 0
var burningTime = 0
var poisonTime = 0
var slowTime = 0
var statusCountdown = 60
var idleCounter = 0

func _ready() -> void:
	health = definition.health * State.difficulty
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
	
	if global_position.y < -10 || idleCounter > 60 * 15:
		health -= 1
	
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
		idleCounter = 0
	elif speed > 0.1:
		modelAnimation.play("Walk")
		model.rotation.y = lerp_angle(model.rotation.y, atan2(-velocity.x, -velocity.z) + PI, 0.2)
		idleCounter = 0
	else:
		modelAnimation.play("Idle")
		idleCounter += 1

func _physics_process(delta):
	if poisonTime:
		poisonTime -= 1
		if poisonTime % 30 == 0:
			damaged(5, Color.GREEN)
	if burningTime:
		burningTime -= 1
		if burningTime % 30 == 0:
			damaged(ceil(burningTime/60) + 1, Color.RED)
	
	if stunTime:
		stunTime -= 1
		status_text.visible = true
		status_text.text = "STUNNED"
	elif slowTime:
		slowTime -= 1
		status_text.visible = true
		status_text.text = "SLOWED"
	else:
		if status_text.visible:
			status_text.visible = false
	
	var targetVelocity = Vector3.ZERO;
	if health <= 0 || modelAnimation.current_animation == 'Attack' || stunTime > 0:
		pass
	elif !navigation_agent.is_navigation_finished():
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		targetVelocity = global_position.direction_to(next_path_position) * (definition.speed * 0.7 if slowTime > 0 else definition.speed)
	else:
		var exit = get_tree().get_nodes_in_group("exit")[0]
		navigation_agent.set_target_position(exit.global_position)

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

func damaged(amount, color = Color.BLACK):
	health -= amount
	if amount > 0:
		var damageLabel = damageLabelScene.instantiate()
		damageLabel.text = str(amount)
		damageLabel.position = global_position
		damageLabel.color = color
		get_parent().add_child(damageLabel)
