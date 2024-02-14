extends Container

var lastWeapons
var weaponButton = preload("res://src/interface/weaponbar/weapon_button.tscn")

signal weapon_selected

var current

func _process(delta):
	if lastWeapons != State.availableWeapons:
		update()
	pass

func update():
	for child in get_children():
		remove_child(child)
		
	for weaponId in State.availableWeapons:
		var weapon = Weapons.getWeapon(weaponId)
		var button: BaseButton = weaponButton.instantiate()
		button.weapon = weapon
		button.pressed.connect( func():
			weapon_selected.emit(weapon.id)
			print('pick')
		)
		button.selected = current == button.weapon.id
		add_child(button)
		
	lastWeapons = State.availableWeapons
	pass

func setSelected(weaponId):
	current = weaponId
	for button in get_children():
		if button.weapon:
			button.setSelected(current == button.weapon.id)
