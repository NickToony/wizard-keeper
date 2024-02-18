extends PanelContainer

var option: Dictionary

@onready var title = $MarginContainer/VBoxContainer/Title
@onready var description = $MarginContainer/VBoxContainer/Description
@onready var cost = $MarginContainer/VBoxContainer/Cost
@onready var button = $MarginContainer/VBoxContainer/Button
@onready var type = $MarginContainer/VBoxContainer/Type

var weapon
var trap
var goldCost = 0

func _ready():
	button.pressed.connect(_on_buy)
	
	if option.has("trap") && option.trap != null:
		trap = Traps.getTrap(option.trap)
		title.text = trap.name
		description.text = trap.description
		cost.text = str(trap.cost) + " gold"
		#goldCost = trap.cost
		type.text = "TRAP"
	elif option.has("weapon") && option.weapon != null:
		weapon = Weapons.getWeapon(option.weapon)
		title.text = weapon.name
		description.text = weapon.description
		cost.text = str(weapon.cost) + " gold"
		#goldCost = weapon.cost
		type.text = getItemLevel(weapon)
	
	update()
	State.weapons_updated.connect(update)
	State.traps_updated.connect(update)
		
func update():
	if weapon:
		if weapon.cost > State.gold:
			button.text = "Too Expensive"
			button.disabled = true
			return
		
		if State.weaponLeft && State.weaponRight:
			button.disabled = true
		else:
			button.disabled = false
	if trap:
		if trap.cost > State.gold:
			button.text = "Too Expensive"
			button.disabled = true
			return
		
		var count = 0
		for t in State.traps:
			if t:
				count += 1
		
		button.disabled = count >= 4
			
	if button.disabled:
		button.text = "Too Many, Sell One First"
	else:
		button.text = "Purchase"
		
		
func getItemLevel(weapon):
	match weapon.level:
		1: return "WEAPON"
		2: return "UPGRADED WEAPON"
		3: return "EPIC WEAPON"
	return "LEGENDARY WEAPON"

func _on_buy():
	if weapon:
		State.gold -= weapon.cost
		
		State.addWeapon(weapon.id)
	
	if trap:
		State.gold -= trap.cost
		
		State.addTrap(trap.id)
			
	
	queue_free()
	
	#if get_parent().get_child_count() == 1:
		#State.shop = false
