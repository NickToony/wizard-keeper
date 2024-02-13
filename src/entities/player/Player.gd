extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

@onready var wizard: Node3D = $Wizard
@onready var modelAnimation: AnimationPlayer = $Wizard/AnimationPlayer
@onready var wizardMesh: MeshInstance3D = $Wizard/EnemyArmature/Skeleton3D/Wizard
@onready var skeleton: Skeleton3D = $Wizard/EnemyArmature/Skeleton3D
var rightArmBone
var leftArmBone

var rightArmAttachment: BoneAttachment3D
var leftArmAttachment: BoneAttachment3D

var weaponMesh: Node3D

var target_velocity = Vector3.ZERO
var weapon_target = Vector3.ZERO
var target_lerp = 0
var casting = false
var attackCooldown = 0
var health = 200
var maxHealth = health
var dead = false

var projectileScene = preload("res://src/attacks/projectile.tscn")
var currentArm = 0

func _ready():
	var wizardArrayMesh: ArrayMesh = wizardMesh.mesh
	wizardArrayMesh.shadow_mesh = $MeshInstance3D.mesh
	
	rightArmBone = skeleton.find_bone("Arm.R")
	leftArmBone = skeleton.find_bone("Arm.L")
	
	rightArmAttachment = BoneAttachment3D.new()
	rightArmAttachment.bone_idx = rightArmBone
	skeleton.add_child(rightArmAttachment)
	
	leftArmAttachment = BoneAttachment3D.new()
	leftArmAttachment.bone_idx = leftArmBone
	skeleton.add_child(leftArmAttachment)
	
	
	weaponMesh = load("res://src/weapons/staff.tscn").instantiate()
	weaponMesh.position.x = 0
	weaponMesh.position.y = 1
	weaponMesh.position.z = 1
	weaponMesh.scale = Vector3(10,10,10)
	rightArmAttachment.add_child(weaponMesh)
	currentArm = rightArmBone
	
	modelAnimation.process_priority = -1
	
	modelAnimation.get_animation("Death").loop_mode = Animation.LOOP_NONE
	modelAnimation.get_animation("Attack").loop_mode = Animation.LOOP_NONE
	
	
func _process(delta):
	if health < 0:
		if !dead:
			modelAnimation.play('Death')
			dead = true
		return
	
	var pointing_at = position
	if casting:
		if target_lerp < 1:
			target_lerp += 5 * delta;
	else:
		if target_lerp > 0:
			target_lerp -= 5 * delta;
	if target_lerp > 0:
		var lerpy = max(target_lerp, 0.01)
		if lerpy < 0.5:
			lerpy /= 4
		var target_pos = skeleton.to_local(skeleton.global_position.lerp(weapon_target, lerpy))
		var bonePos = skeleton.get_bone_pose_position(currentArm)
		var pose : Transform3D = skeleton.get_bone_global_pose(currentArm)
		pose = pose.orthonormalized()
		#var pose_new = pose.looking_at(Vector3(target_pos.x, skeleton.position.y, target_pos.z), Vector3(0,1,0), true)
		var pose_new = pose.looking_at(target_pos, Vector3(0,1,0), true)
		pose_new = pose_new.orthonormalized()
		pose_new.basis = pose_new.basis.rotated(pose_new.basis.x, deg_to_rad(90))
		skeleton.set_bone_pose_rotation(currentArm, pose_new.basis)
		
		#print(position.angle_to(target_pos))
		if position.angle_to(target_pos) > PI/2:
			if currentArm != leftArmBone:
				currentArm = leftArmBone
				rightArmAttachment.remove_child(weaponMesh)
				leftArmAttachment.add_child(weaponMesh)
				target_lerp = 0.2
		else:
			if currentArm != rightArmBone:
				currentArm = rightArmBone
				leftArmAttachment.remove_child(weaponMesh)
				rightArmAttachment.add_child(weaponMesh)
				target_lerp = 0.2
			
		
		weaponMesh.position = Vector3(0, 1, 0.1)
		weaponMesh.rotation.x = lerp_angle(-PI, -deg_to_rad(110), lerpy)
	else:
		weaponMesh.position = Vector3(0, 1, 1)
		weaponMesh.rotation.x = 0
		
	attackCooldown -= 1
	if casting && attackCooldown <= 0:
		attackCooldown = 60;
		var projectile = projectileScene.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = weaponMesh.global_position
		projectile.look_at(weapon_target, Vector3(0, 1, 0), true)
		projectile.update()

		
		


func _physics_process(delta):
	if dead:
		return
	
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
	if !is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		modelAnimation.play("Attack")
		return
	
	if velocity != Vector3.ZERO:
		modelAnimation.play("Run")
		wizard.rotation.y = lerp_angle(wizard.rotation.y, atan2(-velocity.x, -velocity.z) + PI, 10 * delta)
	else:
		modelAnimation.play("Idle")
		
	#var bone_index = skeleton.find_bone('Arm.L')
	#weapon.transform = weapon.transform * skeleton.get_bone_global_pose(bone)
	#var offset = weapon.rotation * Vector3(1, 0, 0)
	#weapon.rotation.x += PI/2
	#weapon.position = skeleton.get_bone_pose_position(bone) + (Vector3(0, 1, 0).tran)
	#weapon.transform = skeleton.transform * skeleton.get_bone_global_pose(bone_index)
	
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var spaceState = get_world_3d().direct_space_state
		var camera: Camera3D = $Camera3D
		var from = camera.project_ray_origin(camera.get_viewport().get_mouse_position())
		var to = from + camera.project_ray_normal(camera.get_viewport().get_mouse_position()) * 100
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collision_mask = pow(2, 9-1)
		var intersection = spaceState.intersect_ray(query)
			
		if !intersection.is_empty():
			var lookPos = intersection.position
			#var wizard: Node3D = $Wizard
			#lookPos.y = wizard.global_position.y
			#wizard.look_at(lookPos, Vector3(0, 1, 0), true)
			#var bone_index = skeleton.find_bone('Arm.L')
			#var bone_pos = skeleton.get_bone_rest(bone_index)
			#skeleton.set_bone_pose_rotation(bone_index, bone_pos.looking_at(lookPos).orthonormalized())
			
			weapon_target = lookPos + Vector3(0, 0.3, 0)
			casting = true
	else:
		#weapon_target = Vector3.ZERO
		casting = false
