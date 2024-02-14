extends TextureButton

var weapon
var selected = false

@onready var label = $Label

func _ready():
	if weapon:
		label.text = weapon.id
	button_mask = MOUSE_BUTTON_MASK_LEFT
	update()
	pass

func setSelected(selected):
	self.selected = selected
	update()

func update():
	button_pressed = selected
	pass
