extends Node

enum Spawnable {
	Goblin,
	Zombie,
	Demon,
}

var levels = {
	"Tutorial": [
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
			"difficulty": 0.5,
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
				"text": "As a Wizard of the Order, I am sworn to protect the portal to upper realms.",
				"target": "exit",
			},{
				"actor": "Wizard",
				"text": "I should place some traps along the route to the portal to limit their escape.",
				"target": "exit",
			}, {
				"actor": "TUTORIAL",
				"text": "1,2,3,4 can be used to select traps to place. Use Q/E to switch back to a weapon any time. Left click to place a trap.",
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
			"traps": ["pool"],
			"gold": 100,
		},
		{
			"cutscenes": [{
				"actor": "Wizard",
				"text": "Time to dust off some of my more deadly traps. The spike trap can be placed on a wall and will hit all enemies in a short area in front of it.",
				"target": null,
			}],
			"attackscenes": [{
				"actor": "Wizard",
				"text": "As expected...",
				"target": "enemies",
			}],
			"enemies": [
				{ "type": Spawnable.Goblin, "count": 20 }
			],
			"traps": ["pool", "spikes"],
		},
		{
			"cutscenes": [{
				"actor": "Wizard",
				"text": "Some more firepower would help. I could try using a different spell.",
				"target": null,
			}, {
				"actor": "TUTORIAL",
				"text": "You can now use the Flame Thrower spell. Toggle between spells with Q/E",
				"target": null,
			}],
			"attackscenes": [{
				"actor": "Zombies",
				"text": "[Groan]...",
				"target": "enemies",
			}, {
				"actor": "Wizard",
				"text": "Zombies as well? I guess we know what happened to the corpses of the long dead prisoners then.",
				"target": "enemies",
			}, {
				"actor": "TUTORIAL",
				"text": "Zombies are slower, but have higher health. They also have a tendency to stand right back up after dying.",
				"target": null,
			}],
			"enemies": [
				{ "type": Spawnable.Zombie, "count": 15 }
			],
			"weapons": ["staff", "staff_flame_thrower"],
		},
		{
			"cutscenes": [{
				"actor": "Wizard",
				"text": "Zombies, what next?",
				"target": null,
			}],
			"attackscenes": [{
				"actor": "Wizard",
				"text": "What is this dark magic...?",
				"target": "enemies",
			}, {
				"actor": "Wizard",
				"text": "They move faster than anything of this realm.",
				"target": "enemies",
			}, {
				"actor": "TUTORIAL",
				"text": "Demons are very fast, but are quite vulnerable in this world. Kill them fast.",
				"target": null,
			}],
			"enemies": [
				{ "type": Spawnable.Demon, "count": 10 }
			],
		},
		{
			"shop": true,
			"cutscenes": [{
				"actor": "Wizard",
				"text": "This is beyond anything I've seen before. Whatever powerful magic is causing this, I must not let it escape.",
				"target": null,
			},{
				"actor": "Wizard",
				"text": "It's time to call upon more of my arsenal to push this evil back.",
				"target": null,
			},{
				"actor": "TUTORIAL",
				"text": "The shop gives you a selection of randomised items to buy.",
				"target": null,
			}],
			"attackscenes": [{
				"actor": "Wizard",
				"text": "They're very keen to get through...",
				"target": "enemies",
			}],
			"enemies": [
				{ "type": Spawnable.Demon, "count": 10 },
				{ "type": Spawnable.Zombie, "count": 20 },
				{ "type": Spawnable.Goblin, "count": 20 }
			],
		},
		{
			"cutscenes": [{
				"actor": "Wizard",
				"text": "Surely there can't be many left.",
				"target": null,
			}],
			"attackscenes": [{
				"actor": "Wizard",
				"text": "I see...",
				"target": "enemies",
			}],
			"enemies": [
				{ "type": Spawnable.Demon, "count": 15 },
				{ "type": Spawnable.Zombie, "count": 30 },
				{ "type": Spawnable.Goblin, "count": 30 }
			],
		}
	],
	"testlevel": [
		{
			"cutscenes": [{
				"actor": "Wizard",
				"text": "Here comes a huge wave of enemies. Good thing I saved up all my pennies. It's time to prepare.",
				"target": null,	
			}],
			"attackscenes": [{
				"actor": "Wizard",
				"text": "Here they come!",
				"target": "enemies",
			}],
			"enemies": [
				{ "type": Spawnable.Goblin, "count": 25 },
				{ "type": Spawnable.Zombie, "count": 25 },
				{ "type": Spawnable.Demon, "count": 10 },
			],
			"weapons": [],
			"traps": [],
			"gold": 1000,
			"shop": true
		},
	]
}
