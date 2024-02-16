extends Node

enum Spawnable {
	Goblin
}

var levels = {
	"level1": [
		{
			"enemies": [
				{ "type": Spawnable.Goblin, "count": 5 }
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
