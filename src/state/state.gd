extends Node

signal weapons_updated
signal weapon_changed
signal traps_updated
signal trap_changed

enum GameMode {
	Wait,
	Play,
	Cutscene,
}

enum WeaponIndex {
	None,
	Left,
	Right
}

var game_mode: GameMode = GameMode.Wait
var music = true
var isPaused = false

var lives = 20
var gold = 0
var weaponLeft = null
var weaponRight = null
var weaponCurrent = WeaponIndex.Left
var traps = [null, null, null, null]
var trapCurrent = null
var nextWave = ''
var gameEnd = false
var shop = false
var rerolls = 0
var difficulty = 1

var cutsceneContent = ''
var cutsceneActor = ''
var cutscenePlay = false
var cutscenePosition = null

func _ready():
	reset()
	process_mode = Node.PROCESS_MODE_ALWAYS
	emit_signal('weapons_updated')
	emit_signal('traps_updated')
	emit_signal("weapon_changed")
	emit_signal("trap_changed")

func _process(delta):
	var pressBuild = Input.is_action_just_pressed("build_mode")
	var pressPause = Input.is_action_just_pressed("pause_mode")
	
	var gameModeChanged = false
	if pressPause:
		isPaused = !isPaused
	if pressBuild && game_mode == GameMode.Wait && !shop:
		game_mode = GameMode.Play
		gameModeChanged = true
	
	if isPaused:
		get_tree().paused = true
	else:
		get_tree().paused = false
	
	if game_mode == GameMode.Cutscene:
		if cutscenePosition || get_tree().get_first_node_in_group("enemies") != null:
			get_tree().paused = true
		
		if Input.is_action_just_pressed("next"):
			game_mode = GameMode.Wait if !cutscenePlay else GameMode.Play
			if gameEnd:
				get_tree().change_scene_to_file("res://wrapper.tscn")
			return
	
	if shop:
		get_tree().paused = true
		return
	
	var setWeapon
	var setTrap
	if Input.is_action_just_pressed("weapon_left"):
		setWeapon = WeaponIndex.Left

	if Input.is_action_just_pressed("weapon_right"):
		setWeapon = WeaponIndex.Right
		
	if Input.is_action_just_pressed("trap1"):
		setTrap = 1
	if Input.is_action_just_pressed("trap2"):
		setTrap = 2
	if Input.is_action_just_pressed("trap3"):
		setTrap = 3
	if Input.is_action_just_pressed("trap4"):
		setTrap = 4
		
	if Input.is_key_pressed(KEY_P):
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.health -= 10
	
	if setWeapon:
		if setWeapon != weaponCurrent:
			var valid = true
			
			if setWeapon == WeaponIndex.Left && !weaponLeft:
				valid = false
			elif setWeapon == WeaponIndex.Right && !weaponRight:
				valid = false
			
			if valid:
				weaponCurrent = setWeapon
				trapCurrent = null
				emit_signal("weapon_changed")
				emit_signal("trap_changed")
	elif setTrap:
		var realIndex = setTrap - 1
		if realIndex != trapCurrent:
			trapCurrent = realIndex
			weaponCurrent = WeaponIndex.None
			emit_signal("weapon_changed")
			emit_signal("trap_changed")

func currentWeapon():
	if weaponCurrent == WeaponIndex.None:
		return
	
	return weaponLeft if weaponCurrent == WeaponIndex.Left else weaponRight
	
func currentWeaponData():
	if currentWeapon() == null:
		return
	
	return Weapons.getWeapon(currentWeapon())

func currentTrap():
	if trapCurrent == null:
		return
		
	if trapCurrent >= traps.size():
		return null
	
	return traps[trapCurrent]
	
func currentTrapData():
	var trap = currentTrap()
	
	return Traps.getTrap(trap) if trap != null else null

func reset():
	lives = 20
	weaponLeft = null
	weaponRight = null
	weaponCurrent = WeaponIndex.None
	traps = [null, null, null, null]
	trapCurrent = null
	nextWave = ''
	game_mode = GameMode.Wait
	gameEnd = false
	rerolls = 0
	gold = 0

func setWeapons(left, right):
	weaponLeft = left
	weaponRight = right
	if weaponCurrent == WeaponIndex.None:
		if weaponLeft:
			weaponCurrent = WeaponIndex.Left
		elif weaponRight:
			weaponCurrent = WeaponIndex.Right
	emit_signal('weapons_updated')
	emit_signal("weapon_changed")
	
func setTraps(newTraps):
	traps = newTraps
	emit_signal('traps_updated')
	emit_signal("trap_changed")

func addWeapon(newWeapon):
	if !weaponLeft:
		setWeapons(newWeapon, State.weaponRight)
	else:
		setWeapons(State.weaponLeft, newWeapon)

func addTrap(newTrap):
	if traps.size() < 4:
		traps.append(newTrap)
	else:
		var freeIndex = -1
		var i = 0
		for t in State.traps:
			if t == null:
				freeIndex = i
				break
			i += 1
		if freeIndex >= 0:
			traps[freeIndex] = newTrap
	
	emit_signal('traps_updated')
	emit_signal("trap_changed")

func removeTrap(index):
	traps[index] = null
	emit_signal('traps_updated')
	emit_signal("trap_changed")
