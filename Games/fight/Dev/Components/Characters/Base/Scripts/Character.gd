extends KinematicBody2D

export var PLAYER_ID := 0
export(NodePath) var OPPONENT
onready var opponent = get_node(OPPONENT)
export(NodePath) onready var HEALTHBAR
onready var healthbar = get_node(HEALTHBAR)

# Movement Properties
export var MAX_FALL_SPEED := 1000
export var GRAVITY := 50
export var JUMP_X_FORCE := 600
export var JUMP_Y_FORCE := 1000
var time_on_floor := 0

# Movement Actuals (updated every frame)
var y_velo := 0
var move_dir := 0
var x_momentum := 0

# Button Inputs (updated every frame)
var dpad_input := 0
var btn_input := 0

var frame = 0
var input_buffer = []

# recall buttons pressed to initiate attack
var dpad_attack := 5
var btn_attack := 0

# hitstun counter and hit-by move
var hit_stun := 0
var hit_by := ''
var hitstun_remaining = 0
var health := 150

# which state are we in
var state = "idle"

func _physics_process(delta):
	frame += 1
	time_on_floor = time_on_floor + 1 if is_on_floor() else 0
	healthbar.value = health
	update_dpad()
	update_btn()
	update_input_buffer(update_dpad(), update_btn(), frame)

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
	return dpad_input

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
		btn_input = 4
	else:
		btn_input = 0
	return btn_input

func update_input_buffer(dpad, btn, frame_state):
	var temp_buffer = input_buffer
	var to_be_removed = []

	if temp_buffer.size() > 0:
		if dpad != temp_buffer.back().dpad_state:
			input_buffer.append(InputState.new(dpad, btn, frame_state))

		if btn != temp_buffer.back().btn_state:
			input_buffer.append(InputState.new(dpad, btn, frame_state))

		for i in range(0, temp_buffer.size()):
			if frame - temp_buffer[i].frame_state >= 60:
				to_be_removed.append(i)

		for k in to_be_removed:
			input_buffer.remove(k)

	else:
		input_buffer.append(InputState.new(dpad, btn, frame_state))

func flush_input_buffer():
	input_buffer = []

func find_buffered_dpad_sequence(buffer, dpad_sequence, window):
	var temp_buffer = buffer
	var dpad_sequence_found = null

	if dpad_sequence != null:
		if temp_buffer.size() >= dpad_sequence.size():
			for i in range(1, dpad_sequence.size() + 1):
				if temp_buffer[-i].dpad_state != dpad_sequence[-i] || frame - temp_buffer[-i].frame_state > window:
					dpad_sequence_found = false
			if dpad_sequence_found != false:
				dpad_sequence_found = true

	if dpad_sequence_found:
		return true
	else:
		return false

func find_buffered_btn(buffer, btn, window):
	var temp_buffer = buffer

	for s in temp_buffer:
		if btn.has(s.btn_state) && frame - s.frame_state <= window:
			return s.btn_state

	return null

class InputState:
	var dpad_state := 5
	var btn_state := 0
	var frame_state := 0

	func _init(dpad, btn, frame):
		dpad_state = dpad
		btn_state = btn
		frame_state = frame