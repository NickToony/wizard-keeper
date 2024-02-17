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
		"penetration": 0,
		"sound": "res://assets/sound/laser2.ogg",
		"cost": 25,
		"color": "#3BE7AF",
		"stun": 0,
		"burning": 0,
		"poison": 0,
		"slow": 0,
		"aoe": 0,
		"upgrades": [
			{
				"id": "staff_fire",
				"name": "Fire Staff",
				"damage": 50,
				"rof": 0.5,
				"speed": 2,
				"color": "#E7593B",
				"description": "Slow and heavy hitting, explodes on contact.",
				"burning": 20,
				"aoe": 1,
				"upgrades": [
					{
						"id": "staff_flame_thrower",
						"name": "Flame Thrower",
						"description": "Rapid firing cone of damage that can pass through multiple enemies. Toasty!",
						"range": 2,
						"speed": 4,
						"count": 6,
						"damage": 6,
						"penetration": 3,
						"rof": 2,
						"burning": 5,
						"aoe": 0,
					},
					{
						"id": "staff_meteor",
						"name": "Meteor",
						"description": "Cataclysmic. Slow but devastating. Large explosion on contact.",
						"range": 20,
						"speed": 1,
						"count": 1,
						"damage": 100,
						"penetration": 0,
						"rof": 0.4,
						"colour": "#D2641C",
						"burning": 10,
						"aoe": 3,
					}
				]
			},
			{
				"id": "staff_water",
				"name": "Water Staff",
				"description": "Give your enemies a nice bath. Low damage, rapid fire. Passes through 1 enemy.",
				"damage": 10,
				"rof": 4,
				"speed": 5,
				"color": "#4C7CF2",
				"penetration": 1,
				"slow": 1,
			},
			{
				"id": "staff_rock",
				"name": "Rock Thrower",
				"description": "Chuck a rock at your enemies. Primitive but it works.",
				"damage": 40,
				"rof": 1,
				"count": 1,
				"range": 20,
				"speed": 3,
				"color": "#583218",
				"stun": 1,
			},
			{
				"id": "staff_poison",
				"name": "Poison Dart",
				"description": "Quick moving dart that slows and poisons an enemy.",
				"damage": 20,
				"rof": 1,
				"count": 1,
				"range": 20,
				"speed": 8,
				"color": "#87DB47",
				"slow": 3,
				"poison": 5,
			},
			{
				"id": "implosion",
				"name": "Implosion",
				"damage": 25,
				"rof": 0.5,
				"count": 20,
				"range": 4,
				"speed": 3,
				"icon": "sword.png",
				"model": "staff.glb",
				"spread": 0.5,
				"penetration": 1,
				"description": "Fire projectiles in every direction.",
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
