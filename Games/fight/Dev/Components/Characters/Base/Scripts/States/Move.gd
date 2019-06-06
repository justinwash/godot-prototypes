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
	print("Moving")

func handle_input(event):
	pass

func update(delta):
	var grounded = character.is_on_floor()

	if grounded:
		move_dir = 0
		momentum = 1

		if [6, 9].has(character.input_buffer[-1].dpad):
			for i in range(0, input_buffer.size() - 2):
				if input_buffer[i].dpad == 6 && input_buffer[-1].frame - input_buffer[i].frame < 30:
					momentum = 10
					break

			move_dir += 1

		elif [4, 7].has(character.dpad_input):
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