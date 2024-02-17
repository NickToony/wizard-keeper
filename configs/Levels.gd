extends Node

enum Spawnable {
	Goblin,
	Zombie,
	Demon,
}

var levels = {
	"level1": [
		{
			"cutscenes": [{
				"actor": "Wizard",
				"text": "Another wonderful day of peace... yet here I am patrolling these dungeons again",
				"target": null,	
			}, {
				"actor": "Wizard",
				"text": "Let's get this over with, there's nothing but rats down here anyway. All the prisoners have long since rotted away.",
				"target": null,
			}],
			"attackscenes": [{
				"actor": "Wizard",
				"text": "What the..? What is that sound?",
				"target": null,
			}, {
				"actor": "Wizard",
				"text": "It seems something is still moving down here...",
				"target": "enemies",
			}, {
				"actor": "TUTORIAL",
				"text": "Q/E is used to switch equipped weapons. Left Click to cast.",
				"target": null,
			}],
			"enemies": [
				{ "type": Spawnable.Goblin, "count": 5 },
			],
			"weapons": ["staff", null],
			"traps": [],
		},
		{
			"cutscenes": [{
				"actor": "Wizard",
				"text": "Goblins? How could anything be alive down here? It's been centuries!",
				"target": null,
			}, {
				"actor": "Wizard",
				"text": "Whatever their purpose, they clearly want to escape this dungeon.",
				"target": null,
			}, {
				"actor": "Wizard",
				"text": "As a Wizard of the Order, I am sworn to protect the upper realms. I can place some traps to catch the enemies off guard.",
				"target": null,
			},{
				"actor": "TUTORIAL",
				"text": "1,2,3,4 can be used to select traps to place. Use Q/E to switch back to a weapon any time.",
				"target": null,
			}],
			"attackscenes": [{
				"actor": "Wizard",
				"text": "More goblins? Here they come...",
				"target": "enemies",
			}],
			"enemies": [
				{ "type": Spawnable.Goblin, "count": 10 }
			],
			"weapons": [],
			"traps": ["pool"],
		},
		{
			"cutscenes": [],
			"attackscenes": [],
			"enemies": [
				{ "type": Spawnable.Goblin, "count": 100 }
			],
			"weapons": [],
			"traps": [],
		}
	]
}
