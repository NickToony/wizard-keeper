extends Node
@onready var calmMusic = $CalmMusic
@onready var actionMusic = $ActionMusic
@onready var animationPlayer = $AnimationPlayer

func _ready():
	calmMusic.process_mode = Node.PROCESS_MODE_ALWAYS
	actionMusic.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass
	
func _physics_process(delta):
	if State.game_mode == State.GameMode.Play:
		if !actionMusic.playing:
			crossfade_to(actionMusic)
	if State.game_mode == State.GameMode.Wait:
		if !calmMusic.playing:
			crossfade_to(calmMusic)

# crossfades to a new audio stream
func crossfade_to(music) -> void:
	if !State.music:
		return

	# The `playing` property of the stream players tells us which track is active. 
	# If it's track two, we fade to track one, and vice-versa.
	if music == calmMusic:
		#calmMusic.stream = audio_stream
		calmMusic.play()
		animationPlayer.play("FadeToCalm")
	else:
		#actionMusic.stream = audio_stream
		actionMusic.play()
		animationPlayer.play("FadeToAction")
		
func reset():
	if !calmMusic.playing:
			crossfade_to(calmMusic)
