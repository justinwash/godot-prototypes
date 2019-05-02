tool
extends Area2D

# framedata
export var STARTUP := 10
export var ACTIVE := 3
export var RECOVERY := 7
export var BLOCKSTUN := 4
export var HITSTUN := 12

# properties
export var DAMAGE := 10
export var CANCEL := 0
export var PRIORITY := 0
export var TYPE := 'high'
export var PUSHBACK_SELF := 2
export var PUSHBACK_OPP := 1

# hitbox
export var HITBOX_X := 0
export var HITBOX_Y := 0
export var HITBOX_W := 100
export var HITBOX_H := 60

# controls
export var activation_dir := 5
export var activation_btn := 1

# lifecycle
var current_frame := 0

# instance
onready var player = get_parent()
onready var edit_mode = Engine.editor_hint
var hitbox := CollisionShape2D.new()

func _init():
	add_child(hitbox)

func _physics_process(delta):	
	if Engine.editor_hint:
		var shape := RectangleShape2D.new()
		shape.set_extents(Vector2(HITBOX_W,HITBOX_H))
		hitbox.set_shape(shape)
		hitbox.set_owner(get_tree().get_edited_scene_root())
	else:
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

func should_activate():
	if player.dpad_input == activation_dir && player.btn_input == activation_btn && !player.busy:
		return true
	else:
		return false
	 

	
	
