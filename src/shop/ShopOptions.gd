extends HBoxContainer

var optionScene = preload("res://src/manager/shop_option.tscn")
var options = []
var shopLast = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass
	
func _process(delta):
	if shopLast != State.shop:
		shopLast = State.shop
		if State.shop:
			generateOptions()
	
func generateOptions():
	options = []
	
	var validTraps = []
	for trap in Traps.Traps:
		if !State.traps.has(trap.id):
			validTraps.append(trap.id)
	var validWeapons = []
	for weapon in Weapons.weaponMap.values():
		#if weapon.parent == null:
		if State.weaponLeft != weapon.id && State.weaponRight != weapon.id:
			validWeapons.append(weapon.id)
	var totalOptions = validTraps.size() + validWeapons.size()

	while options.size() < 3 && options.size() < totalOptions:
		if randi_range(0, 1) == 0:
			if validWeapons.size() > 0:
				var weapon = validWeapons.pick_random()
				options.append({
					"weapon": weapon,
					"trap": null
				})
				validWeapons.erase(weapon)
		else:
			if validTraps.size() > 0:
				var trap = validTraps.pick_random()
				options.append({
					"trap": trap,
					"weapon": null
				})
				validTraps.erase(trap)
	
	for child in get_children():
		remove_child(child)
	
	for option in options:
		var instance = optionScene.instantiate()
		instance.option = option
		instance.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(instance)


func _on_reroll_pressed():
	var cost = State.rerolls * 25
	if cost < State.gold:
		State.rerolls += 1
		State.gold -= cost
		generateOptions()
	pass
