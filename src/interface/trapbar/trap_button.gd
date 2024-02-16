extends TextureButton

var trapIndex = 0

@onready var label = $Label
@onready var icon: TextureRect = $CenterContainer/TextureRect
@onready var key = $Key
@export var keyLabel = '?'

func _ready():
	button_mask = MOUSE_BUTTON_MASK_LEFT
	State.traps_updated.connect(update)
	State.trap_changed.connect(update)
	update()
	
	key.text = keyLabel
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 10
	pass

func update():
	button_pressed = State.trapCurrent == trapIndex
	label.label_settings.font_color = Color.BLACK if button_pressed else Color.WHITE
	key.add_theme_color_override("font_color", Color.BLACK if button_pressed else Color.WHITE) 
	
	if trapIndex < State.traps.size():
		var trap = State.traps[trapIndex]
		if trap:
			var trapData = Traps.getTrap(State.traps[trapIndex])
			label.text = trapData.name
			icon.texture = load(trapData.icon)
			return
	label.text = ''
	icon.visible = false
	
	pass
