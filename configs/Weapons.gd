extends Node

var Weapons = [
	{
		"id": "staff",
		"name": "Staff",
		"damage": 20,
		"rof": 1,
		"count": 1,
		"range": 20,
		"speed": 5,
		"icon": "sword.png",
		"model": "staff.glb",
		"spread": 0.05,
		"passthrough": false,
		"triggerrate": 1,
		"upgrades": [
			{
				"id": "staff_fire",
				"name": "Fire Staff",
				"damage": 60,
				"rof": 2,
				"speed": 50,

				"upgrades": [
					{
						"id": "staff_flame_thrower",
						"name": "Flame Thrower",
						"range": 2,
						"speed": 4,
						"count": 5,
						"damage": 5,
						"passthrough": true,
					}
				]
			},
			{
				"id": "staff_water",
				"name": "Water Staff",
				"damage": 10,
				"rof": 8,
				"speed": 50,
			}
		]
	}
]

var weaponMap = {}

func _ready():
	loadWeapons(Weapons, null);
	print (weaponMap)

func loadWeapons(weaponArray: Array, parent):
	for weapon in weaponArray:
		if !weapon.has("upgrades"):
			weapon.upgrades = []
			
		var upgrades = []
		weaponMap[weapon.id] = weapon
		if parent:
			weaponMap[weapon.id].merge(parent)
		# Nested load
		if weapon["upgrades"].size() > 0:
			loadWeapons(weapon.upgrades, weaponMap[weapon.id])
			# Covert upgrades to array of ids
			for upgrade in weapon.upgrades:
				upgrades.append(upgrade.id)
		
		weaponMap[weapon.id].upgrades = upgrades


func getWeapon(id: String):
	return weaponMap[id]
	
func getUpgradesForWeapon(id: String):
	var weapon = getWeapon(id)
	var result = []
	if weapon.has("upgrades"):
		for child in weapon.upgrades:
			var childWeapon = getWeapon(child)
			result.append(childWeapon)
	return result
