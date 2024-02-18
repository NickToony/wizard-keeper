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
		"cost": highPlace,
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
		"description": "Just like a spike trap, but with poison. Applies a damage over time effect.",
		"cost": veryHighPlace,
		"damage": 80,
		"cooldown": 6,
		"poison": 8,
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
		"cost": lowPlace,
		"damage": 15,
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
		"cost": lowPlace,
		"damage": 0,
		"cooldown": 0.2,
		"slow": 3,
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
		"cost": mediumPlace,
		"damage": 15,
		"cooldown": 1,
		"burning": 6,
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
		"cost": mediumPlace,
		"damage": 15,
		"cooldown": 1,
		"poison": 6,
		"placecost": mediumPlace,
	},
	{
		"id": "zapper",
		"name": "Zapper",
		"wall": true,
		"meshPath": "res://assets/traps/lightning/lightning.glb",
		"scenePath": "res://src/traps/Zapper.tscn",
		"icon": "res://assets/icons/sword.png",
		"description": "Shocking! Does a high amount of damage, but needs a long time to recharge. Stuns enemies that are hit.",
		"cost": highPlace,
		"damage": 50,
		"cooldown": 8,
		"stun": 2,
		"placecost": highPlace,
	},
	{
		"id": "lavajet",
		"name": "Lava Jets",
		"wall": true,
		"meshPath": "res://assets/traps/jets/jets.glb",
		"scenePath": "res://src/traps/LavaJet.tscn",
		"icon": "res://assets/icons/sword.png",
		"description": "For when you really want something dead. Sets targets on fire for a long time.",
		"cost": highPlace,
		"damage": 0,
		"cooldown": 5,
		"burning": 15,
		"placecost": highPlace,
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
			dps += trap.burning
		if trap.has('poison') && trap.poison:
			dps += trap.poison
		var value = dps / float(trap.cost)
		if trap.has('burning') && trap.burning:
			dps += 5 * trap.burning
		if trap.has('poison') && trap.poison:
			dps += 5 * 2 * trap.poison
		var modifierValue = dps / float(trap.cost)
		print(trap.name)
		print('\tdps: ' + str(dps)  + '\tvdps' + str(value)  + '\tmdps' + str(modifierValue))
#
#
func getTrap(id: String):
	return trapMap[id]
