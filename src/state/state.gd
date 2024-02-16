extends Node


var PROJECTILE_BASIC = preload("res://src/attacks/projectile.tscn")

var UNIT_GOBLIN = preload("res://src/entities/enemies/Enemy.tscn")

signal weapons_updated
signal weapon_changed
signal traps_updated
signal trap_changed

enum GameMode {
	Wait,
	Play,
}

enum WeaponIndex {
	None,
	Left,
	Right
}

var game_mode: GameMode = GameMode.Play
var music = true
var isPaused = false

var lives = 20
var weaponLeft = "staff"
var weaponRight = "staff_flame_thrower"
var weaponCurrent = WeaponIndex.Left
var traps = ["pool", "spikes", null, null]
var trapCurrent
var nextWave = ''

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
		get_tree().paused = isPaused
	if pressBuild && game_mode == GameMode.Wait:
		game_mode = GameMode.Play
		gameModeChanged = true
	
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
	
	if setWeapon:
		if setWeapon != weaponCurrent:
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
	
	return traps[trapCurrent]
	
func currentTrapData():
	var trap = currentTrap()
	
	return Traps.getTrap(trap) if trap != null else null

func reset():
	lives = 20
	weaponLeft = "staff"
	weaponRight = null
	weaponCurrent = WeaponIndex.Left
	traps = ["pool", "spikes", null, null]
	trapCurrent
	nextWave = ''
