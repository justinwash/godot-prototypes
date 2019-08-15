extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)

func enter():
	owner.get_node("AnimationPlayer").play("Idle")
	character.state = "idle"
	print("Idling")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	character.move_and_slide(Vector2(0, 1000), Vector2(0, -1))

	if [13].has(character.btn_input) && character.is_on_floor():
		emit_signal("finished", "grab")
	elif character.btn_input != 0:
		character.dpad_attack = character.dpad_input
		character.btn_attack = character.btn_input
		emit_signal("finished", "attack")
	elif [7, 8, 9].has(character.dpad_input) && character.is_on_floor():
		emit_signal("finished", "jump")
	elif [1, 2, 3].has(character.dpad_input) && character.is_on_floor():
		emit_signal("finished", "crouch")
	elif [4, 6].has(character.dpad_input) && character.is_on_floor():
		emit_signal("finished", "move")
