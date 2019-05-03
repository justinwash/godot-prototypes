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
export var TRAVEL := 0
export var PUSHBACK_SELF := 2
export var PUSHBACK_OPP := 1

# hitbox
export var HITBOX_X := 0
export var HITBOX_Y := 0
export var HITBOX_W := 100
export var HITBOX_H := 60

# hurtbox
export var HURTBOX_X := 0
export var HURTBOX_Y := 0
export var HURTBOX_W := 110
export var HURTBOX_H := 60

# controls
export var activation_dir := 5
export var activation_btn := 1

# lifecycle
var current_frame := 0

# instance
onready var player := get_parent()
onready var opponent := player.opponent
var hitbox = null
var hurtbox = null

func _init():
	if Engine.editor_hint:
		hitbox = Area2D.new()
		add_child(hitbox)

func _physics_process(delta):	
	# if we're in the editor
	if Engine.editor_hint:
		var shape := RectangleShape2D.new()
		shape.set_extents(Vector2(HITBOX_W,HITBOX_H))
		hitbox.set_shape(shape)
		hitbox.set_owner(get_tree().get_edited_scene_root())

	# if the game is actually running
	else:
		if should_activate():
			player.busy = true
			current_frame = 1

		if current_frame > 0:
			if current_frame <= STARTUP:
				# startup anim
				pass
			elif current_frame <= STARTUP + ACTIVE:
				# create and activate hitbox and hurtbox
				create_hitbox()
				create_hurtbox()
				# detect if we hit something
				# deal damage
				# deal pushback
				# deal hit/blockstun
			elif current_frame <= STARTUP + ACTIVE + RECOVERY:
				hitbox.free()
				player.hurtboxes[player.hurtboxes.size() - 1].free()
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
	 
func create_hitbox():
	hitbox = Area2D.new()
	var shape := RectangleShape2D.new()
	shape.set_extents(Vector2(HITBOX_W, HITBOX_H))
	hitbox.set_shape(shape)
	hitbox.set_pos(HITBOX_X, HITBOX_Y)
	add_child(hitbox)

func create_hurtbox():
	hurtbox = Area2D.new()
	var shape := RectangleShape2D.new()
	shape.set_extents(Vector2(HURTBOX_W, HURTBOX_H))
	hurtbox.set_shape(shape)
	hurtbox.set_pos(HURTBOX_X, HURTBOX_Y)
	player.hurtboxes.append(hurtbox)

func did_hit():
	# return whether we hit a thing or not
	pass


	
	
