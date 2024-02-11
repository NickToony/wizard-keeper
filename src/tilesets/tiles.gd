@tool

extends Node3D

func _ready():
	if !Engine.is_editor_hint():
		return
		
	for child in get_children():
		child.queue_free()
		remove_child(child);

	var meshScene = load("res://assets/floor/floor.glb")
	var meshes = meshScene.instantiate()
	for mesh: MeshInstance3D in meshes.get_children():
		var copy = mesh.duplicate()
		add_child(copy)
		copy.set_owner(self)
		
		var collisionBody = StaticBody3D.new()
		copy.add_child(collisionBody)
		collisionBody.set_owner(self)
		
		var collisionShape = CollisionShape3D.new()
		collisionBody.add_child(collisionShape)
		collisionShape.set_owner(self)
		
		collisionShape.shape = mesh.mesh.create_convex_shape(false, true)
		#collisionShape.shape = mesh.mesh.create_trimesh_shape()

	for child in get_children():
		child.position = Vector3(0, 0, child.position.z)
