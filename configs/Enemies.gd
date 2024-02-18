extends Node

var Definitions: Dictionary = {
	"Goblin": {
		"mesh": "res://assets/enemies/Goblin.gltf",
		"health": 150,
		"speed": 1,
		"attackspeed": 1,
		"damage": 10,
		"gold": 5,
		"value": 1,
	},
	"Zombie": {
		"mesh": "res://assets/enemies/Zombie.gltf",
		"health": 100,
		"speed": .7,
		"damage": 20,
		"attackspeed": 0.5,
		"respawn": true,
		"lives": 2,
		"gold": 10,
		"value": 2,
	},
	"Demon": {
		"mesh": "res://assets/enemies/Demon.gltf",
		"health": 100,
		"speed": 3,
		"damage": 5,
		"attackspeed": 2,
		"lives": 1,
		"gold": 20,
		"value": 2,
	},
	"Skeleton": {
		"mesh": "res://assets/enemies/Skeleton.gltf",
		"health": 200,
		"speed": 1,
		"damage": 10,
		"attackspeed": 1,
		"lives": 2,
		"gold": 40,
		"value": 5,
	},
	"HeavySkeleton": {
		"mesh": "res://assets/enemies/Skeleton_Armor.gltf",
		"health": 400,
		"speed": .8,
		"damage": 20,
		"attackspeed": 1,
		"lives": 4,
		"gold": 80,
		"value": 10,
	},
	"Giant": {
		"mesh": "res://assets/enemies/Giant.gltf",
		"health": 1000,
		"speed": .7,
		"damage": 100,
		"attackspeed": 0.5,
		"lives": 10,
		"gold": 150,
		"value": 50,
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
