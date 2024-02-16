extends HBoxContainer

func _ready():
	var index = 0
	for child in get_children():
		child.trapIndex = index
		child.update()
		index += 1
