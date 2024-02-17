extends Button

func _process(delta):
	var cost = State.rerolls * 25
	text = "Reroll (Free)" if cost == 0 else "Reroll (" + str(cost) + " gold)"
	visible = cost <= State.gold
	pass
