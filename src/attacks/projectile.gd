extends Area3D

var damageLabelScene = preload("res://src/entities/damagelabel/DamageText.tscn")

@onready var mesh: MeshInstance3D = $MeshInstance3D

var velocity = Vector3.ZERO
var weapon
var startPos
var playerVelocity
var triggerTime = 0

var targetMap = {}
var penetrated = 0
var exploding = false
var explosionMesh = null

func _ready():
	body_entered.connect(_on_body_entered)
	

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
	if exploding:
		explosionMesh.scale += delta * Vector3(10,10,10)
		if explosionMesh.scale.x > weapon.aoe:
			queue_free()
		return
	
	position += velocity * delta
	
	if position.distance_squared_to(startPos) > weapon.range * weapon.range:
		queue_free()
	
func _on_body_entered(body: Node3D):
	if exploding:
		return
	
	if !weapon.aoe && body.is_in_group('enemies'):
		damageBody(body)
		
		if penetrated < weapon.penetration:
			penetrated += 1
			return
	if weapon.aoe:
		exploding = true
		explosionMesh = MeshInstance3D.new()
		explosionMesh.mesh = SphereMesh.new()
		explosionMesh.mesh.material = StandardMaterial3D.new()
		explosionMesh.mesh.material.albedo_color = Color(weapon.color)
		explosionMesh.scale = Vector3.ZERO
		explosionMesh.mesh.radius = 0.5
		add_child(explosionMesh)
		mesh.queue_free()
		
		for enemy in get_tree().get_nodes_in_group('enemies'):
			if enemy.global_position.distance_to(global_position) <= weapon.aoe/2.0:
				damageBody(enemy)
	else:
		queue_free()
		
func damageBody(body):
	body.damaged(weapon.damage)
	if weapon.poison:
		body.poisonTime = weapon.poison * 60
	if weapon.stun:
		body.stunTime = weapon.stun * 60
	if weapon.slow:
		body.slowTime = weapon.slow * 60
	if weapon.burning:
		body.burningTime = weapon.burning * 60

func update(playerVelocity):	
	velocity = (global_transform.basis.z.normalized() * weapon.speed)
	if ((velocity + playerVelocity).length_squared() > velocity.length_squared()):
		velocity += playerVelocity
	position += global_transform.basis.z.normalized() * 0.3
	startPos = position
	
	if weapon:
		mesh.material_override = StandardMaterial3D.new()
		mesh.material_override.albedo_color = Color(weapon.color)
