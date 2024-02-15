extends Node

var Traps = [
	{
		"id": "spikes",
		"name": "Wall o Spikes",
		"wall": true,
		"meshPath": "res://assets/traps/spiketrap.glb",
		"scenePath": "res://src/traps/WallSpikeTrap.tscn"
	},
	{
		"id": "pool",
		"name": "Nasty Pool",
		"wall": false,
		"meshPath": "res://assets/traps/pool.glb",
		"scenePath": "res://src/traps/PoolTrap.tscn"
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