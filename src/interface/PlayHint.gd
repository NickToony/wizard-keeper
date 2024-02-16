extends Label


func _process(delta):
	var count = get_tree().get_nodes_in_group("enemies").size()
	text = "ENEMIES REMAINING: " + str(count)
	pass
