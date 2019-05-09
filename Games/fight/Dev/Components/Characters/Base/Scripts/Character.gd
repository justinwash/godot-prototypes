extends KinematicBody2D

export var PLAYER_ID := 1
# export var PLAYER_SIDE := 1

var dpad_input := 5
var btn_input := 0

var x_momentum := 0

func _physics_process(delta):
	update_dpad()
	update_btn()
	print(x_momentum)

func update_dpad():
	if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_left"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_up"):
			dpad_input = 7
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_down"):
			dpad_input = 1
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_right"):
			dpad_input = 5
		else:
			dpad_input = 4
	elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_right"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_up"):
			dpad_input = 9
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_down"):
			dpad_input = 3
		else:
			dpad_input = 6
	elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_down"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_up"):
			dpad_input = 8
		else:
			dpad_input = 2
	elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_up"):
			dpad_input = 8
	else:
			dpad_input = 5

func update_btn():
	if Input.is_action_just_pressed("pad" + str(PLAYER_ID) + "_btn1"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn2"):
			btn_input = 12
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn3"):
			btn_input = 13
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn4"):
			btn_input = 14
		else:
			btn_input = 1
	elif Input.is_action_just_pressed("pad" + str(PLAYER_ID) + "_btn2"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn3"):
			btn_input = 23
		elif Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn4"):
			btn_input = 24
		else:
			btn_input = 2
	elif Input.is_action_just_pressed("pad" + str(PLAYER_ID) + "_btn3"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_btn4"):
			btn_input = 34
		else:
			btn_input = 3
	elif Input.is_action_just_pressed("pad" + str(PLAYER_ID) + "_btn4"):
		if Input.is_action_pressed("pad" + str(PLAYER_ID) + "_up"):
			btn_input = 4
	else:
		btn_input = 0