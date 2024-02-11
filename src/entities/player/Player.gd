extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

@onready var wizard: Node3D = $Wizard
@onready var modelAnimation: AnimationPlayer = $Wizard/AnimationPlayer
@onready var wizardMesh: MeshInstance3D = $Wizard/EnemyArmature/Skeleton3D/Wizard
@onready var skeleton: Skeleton3D = $Wizard/EnemyArmature/Skeleton3D

var weaponMesh: Node3D

var target_velocity = Vector3.ZERO
var weapon_target = Vector3.ZERO
var lerp_target = Vector3.ZERO

func _ready():
	var wizardArrayMesh: ArrayMesh = wizardMesh.mesh
	wizardArrayMesh.shadow_mesh = $MeshInstance3D.mesh
	
	var boneAttachment: BoneAttachment3D = BoneAttachment3D.new()
	boneAttachment.bone_idx = skeleton.find_bone('Arm.R')
	skeleton.add_child(boneAttachment)
	weaponMesh = load("res://src/weapons/staff.tscn").instantiate()
	weaponMesh.position.x = 0
	weaponMesh.position.y = 1
	weaponMesh.position.z = 1
	weaponMesh.scale = Vector3(10,10,10)
	boneAttachment.add_child(weaponMesh)
	
	modelAnimation.process_priority = -1
	
	
func _process(delta):
	if weapon_target != Vector3.ZERO:
		lerp_target = lerp_target.lerp(weapon_target, 0.1)
	else:
		if lerp_target.distance_to(position) > 0.2:
			lerp_target = lerp_target.lerp(position, 0.1)
		else:
			lerp_target = position
	
	if lerp_target != position:
		var target_pos = skeleton.to_local(lerp_target)
		var rightArmBone = skeleton.find_bone("Arm.R")
		var bonePos = skeleton.get_bone_pose_position(rightArmBone)
		var pose : Transform3D = skeleton.get_bone_global_pose(rightArmBone)
		pose = pose.orthonormalized()
		var pose_new = pose.looking_at(Vector3(target_pos.x, skeleton.position.y, target_pos.z), Vector3(0,1,0), true)
		pose_new = pose_new.orthonormalized()
		pose_new.basis = pose_new.basis.rotated(pose_new.basis.x, deg_to_rad(90))
		skeleton.set_bone_pose_rotation(rightArmBone, pose_new.basis)
		
		#var headBone = skeleton.find_bone("Head")
		#target_pos = skeleton.to_local(weapon_target)
		#pose = skeleton.get_bone_global_pose(headBone)
		#var bonePos = skeleton.get_bone_pose_position(headBone)
		#pose = pose.orthonormalized()
		#pose_new = pose.lookisng_at(Vector3(target_pos.x, bonePos.y, target_pos.z), Vector3(0,1,0), true)
		#pose_new = pose_new.orthonormalized()

		#pose_new.basis.z = pose_new.basis.z.clamp(Vector3(0,0,0), Vector3(.3, .3, .3))
		#skeleton.set_bone_pose_rotation(headBone, pose_new.basis)
		
		weaponMesh.position = Vector3(0, 1, 0.1)
		#weaponMesh.rotation.x = -deg_to_rad(110)
		weaponMesh.rotation.x = lerp_angle(weaponMesh.rotation.x, -deg_to_rad(110), 0.2)
	else:
		weaponMesh.position = Vector3(0, 1, 1)
		#weaponMesh.rotation.x = 0
		weaponMesh.rotation.x = lerp_angle(weaponMesh.rotation.x, 0, 0.2)


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
		wizard.rotation.y = lerp_angle(wizard.rotation.y, atan2(-velocity.x, -velocity.z) + PI, 0.2)
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
		var intersection = spaceState.intersect_ray(query)
			
		if !intersection.is_empty():
			var lookPos = intersection.position
			#var wizard: Node3D = $Wizard
			#lookPos.y = wizard.global_position.y
			#wizard.look_at(lookPos, Vector3(0, 1, 0), true)
			#var bone_index = skeleton.find_bone('Arm.L')
			#var bone_pos = skeleton.get_bone_rest(bone_index)
			#skeleton.set_bone_pose_rotation(bone_index, bone_pos.looking_at(lookPos).orthonormalized())
			
			weapon_target = lookPos
	else:
		weapon_target = Vector3.ZERO
