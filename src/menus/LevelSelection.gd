extends VBoxContainer

var mainScene = preload("res://main.tscn")

@onready var levels = Levels.levels.keys()

@onready var rootScene = get_node("/root/SubViewportContainer/SubViewport")

func _ready():
	for level in levels:
		var button = Button.new()
		button.text = level
		button.pressed.connect(func(): goToLevel(level))
		add_child(button)
	
	Music.reset()
	State.reset()
	pass

func goToLevel(levelName):		
	var main = mainScene.instantiate()
	var level = load("res://src/levels/" + levelName + ".tscn").instantiate()
	main.add_child(level)
	rootScene.add_child(main)
	get_parent().get_parent().queue_free()
	pass
