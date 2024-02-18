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
		"id": "spikespoison",
		"name": "Wall o Poisoned Spikes",
		"wall": true,
		"meshPath": "res://assets/traps/poisonspike.glb",
		"scenePath": "res://src/traps/PoisonSpikeTrap.tscn",
		"icon": "res://assets/icons/sword.png",
		"description": "Spike trap mounted on the wall. High damage, but needs time to recharge.",
		"cost": 50,
		"damage": 50,
		"cooldown": 5,
		"poison": 10,
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
	},
	{
		"id": "tar",
		"name": "Tar Pit",
		"wall": false,
		"meshPath": "res://assets/traps/tar.glb",
		"scenePath": "res://src/traps/TarTrap.tscn",
		"icon": "res://assets/icons/sword.png",
		"description": "Great for trapping all kinds of evil! Does no damage, but slows them down a lot.",
		"cost": 25,
		"damage": 0,
		"cooldown": 0.2,
		"slow": 1,
	},
	{
		"id": "lava",
		"name": "Lava Pit",
		"wall": false,
		"meshPath": "res://assets/traps/lava.glb",
		"scenePath": "res://src/traps/LavaPit.tscn",
		"icon": "res://assets/icons/sword.png",
		"description": "Fill a pit with lava. Damages and sets enemies on fire.",
		"cost": 25,
		"damage":5,
		"cooldown": 1,
		"burning": 5,
	},
	{
		"id": "poison",
		"name": "Toxic Pool",
		"wall": false,
		"meshPath": "res://assets/traps/poisonpool.glb",
		"scenePath": "res://src/traps/PoisonPool.tscn",
		"icon": "res://assets/icons/sword.png",
		"description": "This pool damages and poisons enemies that walk over it.",
		"cost": 25,
		"damage": 5,
		"cooldown": 1,
		"poison": 5,
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
