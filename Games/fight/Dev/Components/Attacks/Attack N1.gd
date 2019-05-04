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

# controls
export var activation_dir := 5
export var activation_btn := 1

# lifecycle
var current_frame := 0

# instance
onready var player := get_parent()
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
		current_frame+=1
		
		if current_frame <= STARTUP:
			# startup anim
			hurtbox.activate()
			pass
		elif current_frame <= STARTUP + ACTIVE:
			# create and activate hitbox and hurtbox
			hitbox.activate()
			hurtbox.activate()
			# detect if we hit something
			# deal damage
			# deal pushback
			# deal hit/blockstun
		elif current_frame <= STARTUP + ACTIVE + RECOVERY:
			hurtbox.activate()
			# recovery animation
			# cancel if able
			pass
		else: 
			current_frame = 0
			player.busy = false

func should_activate():
	if player.dpad_input == activation_dir && player.btn_input == activation_btn && !player.busy && player.is_on_floor():
		return true
	else:
		return false

	
	
