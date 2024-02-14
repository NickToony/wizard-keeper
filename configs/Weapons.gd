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
		"upgrades": [
			{
				"id": "staff_fire",
				"name": "Fire Staff",
				"damage": 60,
				"rof": 0.5,
				"speed": 2,
				"upgrades": [
					{
						"id": "staff_flame_thrower",
						"name": "Flame Thrower",
						"range": 2,
						"speed": 4,
						"count": 6,
						"damage": 6,
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
		],
	}, {
		"id": "implosion",
		"name": "Implosion",
		"damage": 50,
		"rof": 0.1,
		"count": 20,
		"range": 5,
		"speed": 2,
		"icon": "sword.png",
		"model": "staff.glb",
		"spread": 0.5,
		"passthrough": true,
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
