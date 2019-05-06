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
export var PRIORITY := 0
export var TYPE := 'high'
export var TRAVEL := 0
export var PUSHBACK_SELF := 2
export var PUSHBACK_OPP := 1
export var ON_GROUND := true
export var IS_STRING := true

# controls
export var activation_dirs := [4, 5, 6]
export var activation_btns := [1]
export var next_string_btn := 1
export var next_string_delay := 5

# lifecycle
var current_frame := 0
var should_continue_string := false

# instancei
export(NodePath) var player_path
onready var player = get_node(player_path)
onready var hitbox := get_node("Hitbox")
onready var hurtbox := get_node("Hurtbox")

func _physics_process(delta):	
	hitbox.deactivate()
	hurtbox.deactivate()
	# if the game is actually running
	if should_activate():
		player.busy = true
		current_frame = 1

	if current_frame > 0:
		player.busy = true
		current_frame+=1
		
		if current_frame <= STARTUP:
			# startup anim
			hurtbox.activate()
			
			if current_frame > 2:
				check_string_input()
		elif current_frame <= STARTUP + ACTIVE:
			# create and activate hitbox and hurtbox
			hitbox.activate()
			hurtbox.activate()
			check_string_input()
			# detect if we hit something
			# deal damage
			# deal pushback
			# deal hit/blockstun
		elif current_frame <= STARTUP + ACTIVE + RECOVERY:
			check_string_input()
			
			if should_continue_string  && current_frame >= STARTUP + ACTIVE + next_string_delay:
				get_node("Next").current_frame = 1
			else:
				hurtbox.activate()
				# recovery animation
				# cancel if able
			pass
		else: 
			current_frame = 0
			should_continue_string = false
			player.busy = false

func should_activate():
	if activation_dirs.has(player.dpad_input) && activation_btns.has(player.btn_input) && !player.busy && ON_GROUND == player.is_on_floor():
		return true
	else:
		return false

func check_string_input():
	if IS_STRING && player.btn_input == next_string_btn:
		should_continue_string = true
	
