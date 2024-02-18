extends Button

@onready var weapon_container = $"../.."


func _process(delta):
	visible = State.shop && (weapon_container.weapon || weapon_container.trap)
	if visible:
		if weapon_container.weapon:
			text = 'Sell (' + str(Weapons.getWeapon(weapon_container.weapon).cost / 2 ) + ')'
		if weapon_container.trap:
			text = 'Sell (' + str(Traps.getTrap(weapon_container.trap).cost / 2 ) + ')'
	pass
