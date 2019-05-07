extends Node2D

# framedata
export var STARTUP := 10
export var ACTIVE := 3
export var RECOVERY := 7
export var BLOCKSTUN := 7
export var HITSTUN := 12

# properties
export var DAMAGE := 10
export var CANCEL := 0
export var TYPE := 'high'
export var TRAVEL := 0
export var PUSHBACK_SELF := 2
export var PUSHBACK_OPP := 1
export var ON_GROUND := true
export var IS_STRING := true

# controls
export var ACTIVATION_DIRS := [4, 5, 6]
export var ACTIVATION_BTNS := [1]
export var NEXT_STRING_BTN := 1
export var STRING_DELAY := 5

# lifecycle
var current_frame := 0
var should_continue_string := false
export var ANIM_NAME := "Attack G-5-1"

# instancei
export(NodePath) var player_path
onready var player = get_node(player_path)
onready var hitbox := get_node("Hitbox")
onready var hurtbox := get_node("Hurtbox")
onready var anim_player = player.get_node("AnimationPlayer")

func _physics_process(delta):	
	hitbox.deactivate()
#	hurtbox.deactivate()

	if should_activate():
		player.busy = true
		current_frame = 1

	if player.halt:
		current_frame = 0

	if current_frame > 0 && player.stun == 0:
		player.busy = true
		player.move_dir = 0
		current_frame+=1
		
		if current_frame <= STARTUP:
			anim_player.play(ANIM_NAME + " S")
#			hurtbox.activate()
			
			if current_frame > 2:
				check_string_input()

		elif current_frame <= STARTUP + ACTIVE:
			anim_player.play(ANIM_NAME + " A")
			hitbox.activate()
#			hurtbox.activate()

			check_string_input()

		elif current_frame <= STARTUP + ACTIVE + RECOVERY:
			anim_player.play(ANIM_NAME + " R")

			check_string_input()
			
			if should_continue_string  && current_frame >= STARTUP + ACTIVE + STRING_DELAY:
				get_node("Next").current_frame = 1
			else:
				pass
#				hurtbox.activate()
		else: 
			current_frame = 0
			should_continue_string = false
			player.busy = false

func should_activate():
	if ACTIVATION_DIRS.has(player.dpad_input) && ACTIVATION_BTNS.has(player.btn_input) && !player.busy && ON_GROUND == player.is_on_floor():
		return true
	else:
		return false

func check_string_input():
	if IS_STRING && player.btn_input == NEXT_STRING_BTN:
		should_continue_string = true

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)

# this is just to get rid of the unused variable warning. remove me.
func _init():
	STARTUP = STARTUP
	ACTIVE = ACTIVE
	RECOVERY = RECOVERY
	BLOCKSTUN = BLOCKSTUN
	HITSTUN = HITSTUN
	DAMAGE = DAMAGE
	CANCEL = CANCEL
	TYPE = TYPE
	TRAVEL = TRAVEL
	PUSHBACK_SELF = PUSHBACK_SELF
	PUSHBACK_OPP = PUSHBACK_OPP
	ON_GROUND = ON_GROUND
	IS_STRING = IS_STRING
