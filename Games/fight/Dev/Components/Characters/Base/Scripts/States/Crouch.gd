extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)

func enter():
	owner.get_node("AnimationPlayer").play("Crouch")
	print("Crouching")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	if ![1, 2, 3].has(character.dpad_input) || !character.is_on_floor():
		emit_signal("finished", "idle")

