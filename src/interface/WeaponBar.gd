extends HBoxContainer

var lastWeapons
var weaponButton = preload("res://src/interface/weaponbar/weapon_button.tscn")

signal weapon_selected

var current
	
func _ready():
	get_children()[0].weaponIndex = State.WeaponIndex.Left
	get_children()[1].weaponIndex = State.WeaponIndex.Right
	for child in get_children():
		child.update()

func setSelected(weaponId):
	current = weaponId
