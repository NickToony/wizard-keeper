extends TextureProgressBar


var player

func _ready():
	player = get_tree().get_nodes_in_group("players")[0]
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player || !is_instance_valid(player):
		var available = get_tree().get_nodes_in_group("players")
		if available.size() > 0:
			player = available[0]
		else:
			return
	
	value = player.health
	max_value = player.maxHealth
	
	pass
