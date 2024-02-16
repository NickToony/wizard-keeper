extends Resource

class_name LevelPart

enum Spawnables {
	Goblin
}

@export var monsters: Array[Spawnables]

func _init(p_monsters: Array[Spawnables] = []):
	monsters = p_monsters
