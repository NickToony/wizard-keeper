extends Button

func _process(delta):
	text = 'Enable Music' if !Music.enabled else 'Disable Music'

func _on_pressed():
	Music.toggle()
