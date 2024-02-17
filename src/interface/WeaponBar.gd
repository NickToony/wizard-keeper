extends HBoxContainer
	
func _ready():
	get_children()[0].weaponIndex = State.WeaponIndex.Left
	get_children()[1].weaponIndex = State.WeaponIndex.Right
	for child in get_children():
		child.update()
