extends KinematicBody2D

export var MOVE_SPEED = 500
export var JUMP_X_MOMENTUM = 2
const JUMP_FORCE = 1000
const GRAVITY = 50
const MAX_FALL_SPEED = 1000

var y_velo = 0
var move_dir = 0
var momentum = 1

var dpad_input = 5
var btn_input = 0

var busy = false

func _physics_process(delta):
	update_dpad()	
	update_btn()

	if busy == false:
		var grounded = is_on_floor()
	
		if grounded:
			move_dir = 0
			momentum = 1
		
			if dpad_input == 6 || dpad_input == 9:
				move_dir += 1
			elif dpad_input == 4 || dpad_input == 7:
				move_dir -= 1
	
		y_velo += GRAVITY
		if grounded && (dpad_input == 7 || dpad_input == 8 || dpad_input == 9):
			y_velo = -JUMP_FORCE
			momentum = JUMP_X_MOMENTUM
		
		if grounded and y_velo >= 0:
			y_velo = 5
		if y_velo > MAX_FALL_SPEED:
			y_velo = MAX_FALL_SPEED
		
		move_and_slide(Vector2(move_dir * MOVE_SPEED * momentum, y_velo), Vector2(0, -1))
	
func update_dpad():
	if Input.is_action_pressed("pad1_left"):
		if Input.is_action_pressed("pad1_up"):
			dpad_input = 7
		elif Input.is_action_pressed("pad1_down"):
			dpad_input = 1
		elif Input.is_action_pressed("pad1_right"):
			dpad_input = 5
		else:
			dpad_input = 4
	elif Input.is_action_pressed("pad1_right"):
		if Input.is_action_pressed("pad1_up"):
			dpad_input = 9
		elif Input.is_action_pressed("pad1_down"):
			dpad_input = 3
		else:
			dpad_input = 6
	elif Input.is_action_pressed("pad1_up"):
		if Input.is_action_pressed("pad1_down"):
			dpad_input = 5
		else:
			dpad_input = 8
	elif Input.is_action_pressed("pad1_down"):
			dpad_input = 2
	else:
			dpad_input = 5	

func update_btn():
	if Input.is_action_just_pressed("pad1_btn1"):
		if Input.is_action_pressed("pad1_btn2"):
			btn_input = 12
		elif Input.is_action_pressed("pad1_btn3"):
			btn_input = 13
		elif Input.is_action_pressed("pad1_btn4"):
			btn_input = 14
		else:
			btn_input = 1
	elif Input.is_action_just_pressed("pad1_btn2"):
		if Input.is_action_pressed("pad1_btn3"):
			btn_input = 23
		elif Input.is_action_pressed("pad1_btn4"):
			btn_input = 24
		else:
			btn_input = 2
	elif Input.is_action_just_pressed("pad1_btn3"):
		if Input.is_action_pressed("pad1_btn4"):
			btn_input = 34
		else:
			btn_input = 3
	elif Input.is_action_just_pressed("pad1_btn4"):
		if Input.is_action_pressed("pad1_up"):
			btn_input = 4
	else:
		btn_input = 0

