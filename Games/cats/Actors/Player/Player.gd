extends KinematicBody2D

const MOVE_SPEED = 250
const JUMP_FORCE = 800
const GRAVITY = 50
const MAX_FALL_SPEED = 800

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var y_velo = 0
var facing_right = false

func _physics_process(delta):
	var move_dir = 0
	if Input.is_action_pressed("ui_right"):
		move_dir += 1
	if Input.is_action_pressed("ui_left"):
		move_dir -= 1
	
	move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velo), Vector2(0, -1))
	
	var grounded = is_on_floor()
	y_velo += GRAVITY
	if grounded and Input.is_action_just_pressed("ui_up"):
		y_velo = -JUMP_FORCE
	if grounded and y_velo >= 0:
		y_velo = 5
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
	
	if facing_right and move_dir < 0:
		flip()
	if !facing_right and move_dir > 0:
		flip()
	
	if grounded:
		if move_dir == 0:
			play_anim("idle")
		if move_dir > 0:
			play_anim("right")
		if move_dir < 0:
			play_anim("left")
	else:
		if move_dir > 0:
			play_anim("jump_right")
		if move_dir < 0:
			play_anim("jump_left")

func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)