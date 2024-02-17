extends PanelContainer

var option: Dictionary

@onready var title = $MarginContainer/VBoxContainer/Title
@onready var description = $MarginContainer/VBoxContainer/Description
@onready var cost = $MarginContainer/VBoxContainer/Cost
@onready var button = $MarginContainer/VBoxContainer/Button
@onready var type = $MarginContainer/VBoxContainer/Type

func _ready():
	if option.has("trap") && option.trap != null:
		var trap = Traps.getTrap(option.trap)
		title.text = trap.name
		description.text = trap.description
		cost.text = str(trap.cost) + " gold"
		type.text = "TRAP"
	elif option.has("weapon") && option.weapon != null:
		var weapon = Weapons.getWeapon(option.weapon)
		title.text = weapon.name
		description.text = weapon.description
		cost.text = str(weapon.cost) + " gold"
		type.text = getItemLevel(weapon)
		
func getItemLevel(weapon):
	match weapon.level:
		1: return "WEAPON"
		2: return "UPGRADED WEAPON"
		3: return "EPIC WEAPON"
	return "LEGENDARY WEAPON"
