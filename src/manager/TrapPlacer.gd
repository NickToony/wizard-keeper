extends Node3D

@onready var floors: GridMap = $"../World/floors"
@onready var walls: GridMap = $"../World/walls"
@onready var scenery: GridMap = $"../World/scenery"
@onready var wallTraps: Node3D = $"../WallTraps"
@onready var floorTraps: Node3D = $"../FloorTraps"

var damageLabelScene = preload("res://src/entities/damagelabel/DamageText.tscn")

var buildMeshInstance: Node3D
var player
var trap
var material = StandardMaterial3D.new()

var lastTrapId = null

func _ready():	
	player = get_tree().get_nodes_in_group("players")[0]
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

func _process(delta):
	if State.currentTrap() && player.mousePosition && !player.building:
		if lastTrapId != State.currentTrap():
			lastTrapId = State.currentTrap()
			
			if buildMeshInstance:
				remove_child(buildMeshInstance)
			
			trap = State.currentTrapData()
			var buildMesh = load(trap.meshPath)
			buildMeshInstance = buildMesh.instantiate()
			if !trap.wall:
				buildMeshInstance.rotation.z = PI/2
			
			for mesh: MeshInstance3D in buildMeshInstance.get_children():
				for surface in range(mesh.get_surface_override_material_count()):
					mesh.set_surface_override_material(surface, material)
			
			add_child(buildMeshInstance)

		
		var floorPosition = floors.local_to_map(player.mousePosition)
		var wallPosition = walls.local_to_map(player.mousePosition)
		
		var snapPosition = floors.map_to_local(floorPosition)
		var validPosition = true
		
		if floors.get_cell_item(floorPosition) == GridMap.INVALID_CELL_ITEM:
			validPosition = false
		if scenery.get_cell_item(wallPosition) != GridMap.INVALID_CELL_ITEM:
			validPosition = false
		if trap.cost > State.gold:
			validPosition = false
			if Input.is_action_just_pressed("mouse_left"):
				var damageLabel = damageLabelScene.instantiate()
				damageLabel.text = 'Not enough gold'
				damageLabel.position = snapPosition
				damageLabel.color = Color.RED
				get_parent().add_child(damageLabel)
		var wallDir: Vector3i
		if trap.wall:
			var toCheck = [Vector3i.LEFT, Vector3i.RIGHT, Vector3i.FORWARD, Vector3i.BACK ]
			var found = false
			var dist = 99999
			for check in toCheck:
				if floors.get_cell_item(floorPosition + check) == GridMap.INVALID_CELL_ITEM:
					var d = floors.map_to_local(floorPosition + check).distance_squared_to(player.mousePosition)
					if !found:
						found = true
						wallDir = check
						dist = d
					elif d < dist:
						wallDir = check
						dist = d
			if !found:
				validPosition = false
				buildMeshInstance.rotation = Vector3.ZERO
			else:
				buildMeshInstance.rotation.y = Vector2(-wallDir.x, wallDir.z).angle() - PI/2
				#snapPosition = floors.map_to_local(floorPosition + dir)
		
		var trapLayer = wallTraps if trap.wall else floorTraps
		
		#Finally check no other trap at position
		for otherTrap in trapLayer.get_children():
			if otherTrap.position == snapPosition:
				if !trap.wall:
					validPosition = false
				else:
					#if otherTrap.rotation.y == buildMeshInstance.rotation.y:
					validPosition = false
				break
		
		if validPosition:			
			material.albedo_color = Color.WHITE
		else:
			material.albedo_color = Color.RED
			
		material.albedo_color.a = 0.5
		buildMeshInstance.visible = true
		buildMeshInstance.position = snapPosition
		
		if validPosition && Input.is_action_just_pressed("mouse_left"):
			player.triggerBuild()
			
			var trapInstance = load(trap.scenePath).instantiate()
			trapInstance.trap = trap
			trapInstance.position = snapPosition
			State.gold -= trap.cost
			if !trap.wall:
				#trapInstance.rotation.z = PI/2
				pass
			else:
				trapInstance.rotation.y = buildMeshInstance.rotation.y
			trapLayer.add_child(trapInstance)
	elif buildMeshInstance:
		buildMeshInstance.visible = false
		
