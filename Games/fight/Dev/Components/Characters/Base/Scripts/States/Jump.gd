extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)

var jumped := false

func enter():
	jumped = false

func update(delta):
	var grounded = character.time_on_floor > 3 && character.is_on_floor()

	if grounded && !jumped:
		print("Jumping")
		character.state = "jump"
		owner.get_node("AnimationPlayer").play("Jump")
		character.move_dir = 0

		if [9].has(character.dpad_input):
			character.move_dir += 1
		elif [7].has(character.dpad_input):
			character.move_dir -= 1
		character.y_velo = -character.JUMP_Y_FORCE

	character.y_velo += character.GRAVITY

	if character.y_velo > character.MAX_FALL_SPEED:
		character.y_velo = character.MAX_FALL_SPEED

	character.move_and_slide(Vector2(character.move_dir * character.JUMP_X_FORCE, character.y_velo), Vector2(0, -1))
	jumped = true

	if character.btn_input != 0:
		character.dpad_attack = character.dpad_input
		character.btn_attack = character.btn_input
		emit_signal("finished", "attack")
	elif jumped && character.is_on_floor():
		emit_signal("finished", "idle")