extends Node

enum Spawnable {
	Goblin,
	Zombie,
	Demon,
}

var levels = {
	"level1": [
		{
			"enemies": [
				{ "type": Spawnable.Goblin, "count": 5 },
				{ "type": Spawnable.Zombie, "count": 5 },
				{ "type": Spawnable.Demon, "count": 5 },
			]	
		},
		{
			"enemies": [
				{ "type": Spawnable.Goblin, "count": 25 }
			]	
		},
		{
			"enemies": [
				{ "type": Spawnable.Goblin, "count": 100 }
			]	
		}
	]
}
