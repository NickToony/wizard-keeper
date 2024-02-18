extends Node

var veryHighPlace = 80
var highPlace = 60
var mediumPlace = 40
var lowPlace = 20

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
		"placecost": highPlace,
		"damage": 100,
		"cooldown": 6,
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
		"damage": 30,
		"cooldown": 6,
		"poison": 5,
		"placecost": veryHighPlace,
	},
	{
		"id": "pool",
		"name": "Acidic Pool",
		"wall": false,
		"meshPath": "res://assets/traps/pool.glb",
		"scenePath": "res://src/traps/PoolTrap.tscn",
		"icon": "res://assets/icons/sword.png",
		"description": "A pool of acidic goo. Hurts enemies as they walk over it, but magically harmless to wizards!",
		"cost": 25,
		"damage": 20,
		"cooldown": 1,
		"placecost": lowPlace,
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
		"slow": 2,
		"placecost": lowPlace,
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
		"damage": 15,
		"cooldown": 1,
		"burning": 3,
		"placecost": mediumPlace,
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
		"damage": 15,
		"cooldown": 1,
		"poison": 3,
		"placecost": mediumPlace,
	}
]

var trapMap = {}

func _ready():
	loadTraps(Traps);
	printTrapStats()
#
func loadTraps(traps: Array):
	for trap in traps:
		trapMap[trap.id] = trap

func printTrapStats():
	print('\n\nTRAPS\n-----')
	for trap in Traps:
		var dps = trap.damage / trap.cooldown
		if trap.has('burning') && trap.burning:
			dps += 5 * trap.burning
		if trap.has('poison') && trap.poison:
			dps += 5 * 2 * trap.poison
		var value = dps / float(trap.cost)
		print(trap.name)
		print('\tdps: ' + str(dps)  + '\tvdps' + str(value))
#
#
func getTrap(id: String):
	return trapMap[id]
