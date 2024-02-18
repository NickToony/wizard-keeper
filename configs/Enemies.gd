extends Node

var Definitions: Dictionary = {
	"Goblin": {
		"mesh": "res://assets/enemies/Goblin.gltf",
		"health": 150,
		"speed": 1,
		"attackspeed": 1,
		"damage": 10,
		"gold": 4,
		"value": 1,
	},
	"Zombie": {
		"mesh": "res://assets/enemies/Zombie.gltf",
		"health": 100,
		"speed": .8,
		"damage": 20,
		"attackspeed": 0.5,
		"respawn": true,
		"lives": 2,
		"gold": 6,
		"value": 2,
	},
	"Demon": {
		"mesh": "res://assets/enemies/Demon.gltf",
		"health": 150,
		"speed": 2.6,
		"damage": 5,
		"attackspeed": 2,
		"lives": 1,
		"gold": 10,
		"value": 3,
	},
	"Skeleton": {
		"mesh": "res://assets/enemies/Skeleton.gltf",
		"health": 300,
		"speed": 1,
		"damage": 10,
		"attackspeed": 1,
		"lives": 2,
		"gold": 10,
		"value": 5,
	},
	"HeavySkeleton": {
		"mesh": "res://assets/enemies/Skeleton_Armor.gltf",
		"health": 500,
		"speed": .8,
		"damage": 20,
		"attackspeed": 1,
		"lives": 4,
		"gold": 20,
		"value": 10,
	},
	"Giant": {
		"mesh": "res://assets/enemies/Giant.gltf",
		"health": 800,
		"speed": .8,
		"damage": 101,
		"attackspeed": 0.5,
		"lives": 10,
		"gold": 40,
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
