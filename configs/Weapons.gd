extends Node

var Weapons = [
	{
		"id": "staff",
		"name": "Staff",
		"description": "Basic staff that fires a single long ranged projectile.",
		"damage": 20,
		"rof": 1,
		"count": 1,
		"range": 20,
		"speed": 5,
		"icon": "sword.png",
		"model": "staff.glb",
		"spread": 0.05,
		"passthrough": false,
		"sound": "res://assets/sound/laser2.ogg",
		"cost": 25,
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
						"rof": 2,
					}
				]
			},
			{
				"id": "staff_water",
				"name": "Water Staff",
				"description": "Give your enemies a nice bath. Low damage, rapid fire.",
				"damage": 10,
				"rof": 4,
				"speed": 5,
			},
			{
				"id": "implosion",
				"name": "Implosion",
				"damage": 50,
				"rof": 0.3,
				"count": 20,
				"range": 5,
				"speed": 2,
				"icon": "sword.png",
				"model": "staff.glb",
				"spread": 0.5,
				"passthrough": true,
				"description": "Testing",
				"cost": 100,
			}
		],
	}
]

var weaponMap = {}

func _ready():
	loadWeapons(Weapons, null, 1);
	print (weaponMap)

func loadWeapons(weaponArray: Array, parent, level):
	for weapon in weaponArray:
		if !weapon.has("upgrades"):
			weapon.upgrades = []
			
		var upgrades = []
		weaponMap[weapon.id] = weapon
		weaponMap[weapon.id].level = level
		if parent:
			weaponMap[weapon.id].merge(parent)
			weapon.parent = parent
		else:
			weapon.parent = null
		# Nested load
		if weapon["upgrades"].size() > 0:
			loadWeapons(weapon.upgrades, weaponMap[weapon.id], level + 1)
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
