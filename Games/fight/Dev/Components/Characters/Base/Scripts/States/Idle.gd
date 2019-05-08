extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)

func enter():
	owner.get_node("AnimationPlayer").play("Idle")
	print("Idling")

func handle_input(event):
	return .handle_input(event)

# warning-ignore:unused_argument
func update(delta):
	character.move_and_slide(Vector2(0, 1000), Vector2(0, -1))
	
	if [7, 8, 9].has(character.dpad_input):
		emit_signal("finished", "jump")
	if [1, 2, 3].has(character.dpad_input) && character.is_on_floor():
		emit_signal("finished", "crouch")
	if [4, 6].has(character.dpad_input) && character.is_on_floor():
		emit_signal("finished", "move")