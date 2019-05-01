tool
extends Area2D

# framedata
export var STARTUP = 10
export var ACTIVE = 3
export var RECOVERY = 8
export var BLOCKSTUN = 4
export var HITSTUN = 12

# properties
export var DAMAGE = 10
export var CANCEL = STARTUP + ACTIVE + RECOVERY
export var PRIORITY = 0
export var TYPE: 'high' || 'mid' || 'low' || 'throw' || 'parry' = 'high'
export var PUSHBACK_SELF = 2
export var PUSHBACK_OPP = 1

# hitbox
export var HITBOX_X = 0
export var HITBOX_Y = 0
export var HITBOX_W = 100
export var HITBOX_H = 60

# controls
export var activation_dir = 5
export var activation_btn = 1

# lifecycle
var current_frame = 0

# instance
var player = get_root()
var editor_mode = Engine.iseditor_hint()

func _physics_process():
	if editor_mode:
		# create visual hitbox for editing
		pass

	if should_activate():
		player.busy = true
		current_frame = 1

	if current_frame > 0 && current_frame <= STARTUP + ACTIVE + RECOVERY:
		if current_frame <= STARTUP:
			# startup anim
			pass
		elif current_frame <= ACTIVE:
			# create and activate hitbox Collider2D
			# detect if we hit a hurtbox
			# deal damage
			# deal pushback
			# deal hit/blockstun
			pass
		elif current_frame <= RECOVERY:
			# recovery animation
			# cancel if able
			pass
		else: 
			current_frame = 0
			player.busy = false
		
		current_frame+=1

	update()

func _draw():
	# draw hitbox at x,y,w,h
	pass

func should_activate():
	if player.dpad_input == activation_dir && player.btn_input == activation_btn && !player.busy:
		return true
	else:
		return false
	 

	
	
