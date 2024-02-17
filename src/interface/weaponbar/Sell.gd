extends Button

@onready var weapon_container = $"../.."


func _process(delta):
	visible = State.shop && (weapon_container.weapon || weapon_container.trap)
	pass
