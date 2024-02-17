extends TextureButton

var weaponIndex = 0

@export var keyLabel = '?'

@onready var label = $Label
@onready var key = $Key
@onready var icon: TextureRect = $CenterContainer/TextureRect

func _ready():
	button_mask = MOUSE_BUTTON_MASK_LEFT
	State.weapons_updated.connect(update)
	State.weapon_changed.connect(update)
	update()
	
	key.text = keyLabel
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 10
	pass

func update():
	button_pressed = State.weaponCurrent == weaponIndex
	var weapon = State.weaponLeft if weaponIndex == State.WeaponIndex.Left else State.weaponRight
	if weapon:
		var weaponData = Weapons.getWeapon(weapon)
		label.text = weaponData.name
		icon.visible = true
	else:
		label.text = ''
		icon.visible = false
		
	label.label_settings.font_color = Color.BLACK if button_pressed else Color.WHITE
	key.add_theme_color_override("font_color", Color.BLACK if button_pressed else Color.WHITE) 
