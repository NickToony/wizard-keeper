extends TextureButton

@onready var label = $Label
@onready var key = $Key
@onready var icon: TextureRect = $CenterContainer/TextureRect
@onready var cost = $Cost

func _ready():
	button_mask = MOUSE_BUTTON_MASK_LEFT
	update()
	
	key.text = get_parent().keyLabel
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 10
	
	cost.label_settings = LabelSettings.new()
	cost.label_settings.font_size = 9
	pass

func update():
	cost.visible = false
	if get_parent().weaponIndex != null:
		button_pressed = State.weaponCurrent == get_parent().weaponIndex
		if get_parent().weapon:
			var weaponData = Weapons.getWeapon(get_parent().weapon)
			label.text = weaponData.name
			icon.visible = true
		else:
			label.text = ''
			icon.visible = false
			
		label.label_settings.font_color = Color.BLACK if button_pressed else Color.WHITE
		key.add_theme_color_override("font_color", Color.BLACK if button_pressed else Color.WHITE)
		cost.label_settings.font_color = Color.BLACK if button_pressed else Color.WHITE
	if get_parent().trapIndex != null:
		button_pressed = State.trapCurrent == get_parent().trapIndex
		label.label_settings.font_color = Color.BLACK if button_pressed else Color.WHITE
		key.add_theme_color_override("font_color", Color.BLACK if button_pressed else Color.WHITE) 
		cost.label_settings.font_color = Color.BLACK if button_pressed else Color.WHITE
		
		if get_parent().trap:
			var trapData = Traps.getTrap(get_parent().trap)
			label.text = trapData.name
			icon.texture = load(trapData.icon)
			icon.visible = true
			cost.visible = true
			var calculatedCost = trapData.cost
			calculatedCost *= 1 + (State.trapCount(trapData.id) * 0.2)
			cost.text = str(calculatedCost) + ' gold'
			return
		label.text = ''
		icon.visible = false
