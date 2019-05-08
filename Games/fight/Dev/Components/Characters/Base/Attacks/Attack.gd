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
onready var anim_player = player.get_node("AnimationPlayer")

func _physics_process(delta):

	if (should_activate() || anim_player.current_animation == ANIM_NAME) && player.stun == 0:
		play_anim(ANIM_NAME)
		player.busy = true
		player.move_dir = 0
		check_string_input()
			
		if should_continue_string  && current_frame >= STARTUP + ACTIVE + STRING_DELAY:
			get_node("Next").current_frame = 1
		
		if anim_player.current_animation != ANIM_NAME:
			current_frame = 0
			should_continue_string = false
			player.busy = false

func should_activate():
	if ACTIVATION_DIRS.has(player.dpad_input) && ACTIVATION_BTNS.has(player.btn_input)  && ON_GROUND == player.is_on_floor():
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
