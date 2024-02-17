extends Area3D

var damageLabelScene = preload("res://src/entities/damagelabel/DamageText.tscn")

@onready var mesh: MeshInstance3D = $MeshInstance3D

var velocity = Vector3.ZERO
var weapon
var startPos
var playerVelocity
var triggerTime = 0
var targets = []
var targetMap = {}
var penetrated = 0

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	

#func _process(delta):
	#if weapon.passthrough:
		#triggerTime -= 1
		#if triggerTime < 0:
			#triggerTime = 60 / weapon.triggerrate
			#for target in targets:
				#target.health -= weapon.damage
				#var damageLabel = damageLabelScene.instantiate()
				#damageLabel.text = str(weapon.damage)
				#damageLabel.position = target.position
				#get_parent().add_child(damageLabel)

func _physics_process(delta):
	position += velocity * delta
	
	if position.distance_squared_to(startPos) > weapon.range * weapon.range:
		queue_free()
	
func _on_body_entered(body: Node3D):
	
	if (body.is_in_group('enemies')):
		body.damaged(weapon.damage)
		if weapon.poison:
			body.poisonTime = weapon.poison * 60
		if weapon.stun:
			body.stunTime = weapon.stun * 60
		if weapon.slow:
			body.slowTime = weapon.slow * 60
		if weapon.burning:
			body.burningTime = weapon.burning * 60
		
		if penetrated < weapon.penetration:
			penetrated += 1
			return
	queue_free()
	
func _on_body_exited(body: Node3D):
	if body.is_in_group('enemies'):
		targets.erase(body)

func update(playerVelocity):
	velocity = (global_transform.basis.z.normalized() * weapon.speed)
	if ((velocity + playerVelocity).length_squared() > velocity.length_squared()):
		velocity += playerVelocity
	position += global_transform.basis.z.normalized() * 0.3
	startPos = position
	
	if weapon:
		mesh.material_override = StandardMaterial3D.new()
		mesh.material_override.albedo_color = Color(weapon.color)
