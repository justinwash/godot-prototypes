extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
onready var opponent = character.opponent

# Movement
export var MOVE_SPEED := 300
var move_dir := 0
var momentum := 1
var max_distance = 1280

func enter():
	owner.get_node("AnimationPlayer").play("Move")
	character.state = "move"
	print("Moving")

func handle_input(event):
	pass

func update(delta):
	var grounded = character.is_on_floor()

	if grounded:
		move_dir = 0
		momentum = 1

		var temp_buffer = character.input_buffer

		if [6].has(character.dpad_input):
			if character.find_buffered_dpad_sequence(temp_buffer, [6,5,6], 16):
				character.flush_input_buffer()
				if character.PLAYER_ID == 1:
					emit_signal("finished", "dash_forward")
				else:
					emit_signal("finished", "dash_backward")
			else:
				momentum = 1
			move_dir += 1

		elif [4].has(character.dpad_input):
			if character.find_buffered_dpad_sequence(temp_buffer, [4,5,4], 16):
				character.flush_input_buffer()
				if character.PLAYER_ID == 1:
					emit_signal("finished", "dash_backward")
				else:
					emit_signal("finished", "dash_forward")
			else:
				momentum = 1
			move_dir -= 1

		var opponent_distance = character.position.x - character.opponent.position.x

		if opponent_distance > 0 && move_dir > 0:
			if opponent_distance + move_dir > 900:
				move_dir = 0

		if opponent_distance < 0 && move_dir < 0:
			if abs(opponent_distance + move_dir) > 900:
				move_dir = 0

	character.move_and_slide(Vector2(move_dir * MOVE_SPEED * momentum, 1000), Vector2(0, -1))

	if character.btn_input != 0:
		character.dpad_attack = character.dpad_input
		character.btn_attack = character.btn_input
		emit_signal("finished", "attack")
	if ![4, 6].has(character.dpad_input) && grounded:
		emit_signal("finished", "idle")