extends VBoxContainer

@onready var icon_button = $IconButton

@export var keyLabel = '?'

var weaponIndex = null
var trapIndex = null

var weapon = null
var trap = null

func _ready():
	State.weapons_updated.connect(update)
	State.weapon_changed.connect(update)
	State.traps_updated.connect(update)
	State.trap_changed.connect(update)

func update():
	weapon = null
	trap = null
	
	if weaponIndex != null:
		weapon = State.weaponLeft if weaponIndex == State.WeaponIndex.Left else State.weaponRight
	if trapIndex != null && trapIndex < State.traps.size():
		trap = State.traps[trapIndex]
	
	icon_button.update()


func _on_sell_pressed():
	if weapon:
		var weaponData = Weapons.getWeapon(weapon)
		State.gold += weaponData.cost / 2
		
		if weaponIndex == State.WeaponIndex.Left:
			State.setWeapons(null, State.weaponRight)
		else:
			State.setWeapons(State.weaponLeft, null)
	if trap:
		var trapData = Traps.getTrap(trap)
		State.gold + trapData.cost / 2
		
		State.removeTrap(trapIndex)
	pass
