extends Node

var Definitions: Dictionary = {
	"Goblin": {
		"mesh": "res://assets/enemies/Goblin.gltf",
		"health": 150,
		"speed": 1,
		"attackspeed": 1,
		"damage": 10,
	},
	"Zombie": {
		"mesh": "res://assets/enemies/Zombie.gltf",
		"health": 100,
		"speed": .7,
		"damage": 20,
		"attackspeed": 0.5,
		"respawn": true,
		"lives": 2,
		"gold": 2,
	},
	"Demon": {
		"mesh": "res://assets/enemies/Demon.gltf",
		"health": 100,
		"speed": 3,
		"damage": 5,
		"attackspeed": 2,
		"lives": 1,
		"gold": 3,
	}
}

func _ready():
	for key in Definitions.keys():
		Definitions[key].merge({
			"health": 100,
			"speed": 1,
			"respawn": false,
			"attackspeed": 1,
			"damage": 10,
			"scale": 0.15,
			"gold": 1,
			"lives": 1,
		}, false)
