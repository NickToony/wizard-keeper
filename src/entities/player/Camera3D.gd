extends Camera3D

var basePos
var locked = true

func _ready():
	basePos = position
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	var targetPos = basePos
	var asGlobal = false
	if State.game_mode == State.GameMode.Cutscene && State.cutscenePosition != null:
		var target = get_tree().get_first_node_in_group(State.cutscenePosition)
		if target:
			targetPos = basePos + target.global_position
			asGlobal = true
			locked = false
	else:
		targetPos = basePos
	
	if locked:
		position = targetPos
	elif asGlobal:
		global_position = global_position.lerp(targetPos, 0.2)
	else:
		position = position.lerp(targetPos, 0.2)
		if position.distance_to(targetPos) < 10:
			locked = true
