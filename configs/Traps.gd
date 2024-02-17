extends Node

var Traps = [
	{
		"id": "spikes",
		"name": "Wall o Spikes",
		"wall": true,
		"meshPath": "res://assets/traps/spiketrap.glb",
		"scenePath": "res://src/traps/WallSpikeTrap.tscn",
		"icon": "res://assets/icons/sword.png",
		"description": "Spike trap mounted on the wall. High damage, but needs time to recharge.",
		"cost": 50,
		"damage": 50,
		"cooldown": 5,
		"stun": 0,
		"burning": 0,
		"poison": 0,
		"slow": 0,
		"aoe": 0,
	},
	{
		"id": "pool",
		"name": "Nasty Pool",
		"wall": false,
		"meshPath": "res://assets/traps/pool.glb",
		"scenePath": "res://src/traps/PoolTrap.tscn",
		"icon": "res://assets/icons/sword.png",
		"description": "A pool of acidic goo. Hurts enemies as they walk over it, but magically harmless to wizards!",
		"cost": 25,
		"damage": 10,
		"cooldown": 1,
	}
]

var trapMap = {}

func _ready():
	loadTraps(Traps);
	#print (weaponMap)
#
func loadTraps(traps: Array):
	for trap in traps:
		trapMap[trap.id] = trap


#func loadWeapons(weaponArray: Array, parent):
	#for weapon in weaponArray:
		#if !weapon.has("upgrades"):
			#weapon.upgrades = []
			#
		#var upgrades = []
		#weaponMap[weapon.id] = weapon
		#if parent:
			#weaponMap[weapon.id].merge(parent)
		## Nested load
		#if weapon["upgrades"].size() > 0:
			#loadWeapons(weapon.upgrades, weaponMap[weapon.id])
			## Covert upgrades to array of ids
			#for upgrade in weapon.upgrades:
				#upgrades.append(upgrade.id)
		#
		#weaponMap[weapon.id].upgrades = upgrades
#
#
func getTrap(id: String):
	return trapMap[id]
	#
#func getUpgradesForWeapon(id: String):
	#var weapon = getWeapon(id)
	#var result = []
	#if weapon.has("upgrades"):
		#for child in weapon.upgrades:
			#var childWeapon = getWeapon(child)
			#result.append(childWeapon)
	#return result
