extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)

func enter():
	owner.get_node("AnimationPlayer").play("Crouch")
	print(str(character.PLAYER_ID) + " Crouching")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	if character.btn_input != 0:
		character.dpad_attack = character.dpad_input
		character.btn_attack = character.btn_input
		emit_signal("finished", "attack")
	if [7, 8, 9].has(character.dpad_input) && character.is_on_floor():
		emit_signal("finished", "jump")
	if ![1, 2, 3].has(character.dpad_input) || !character.is_on_floor():
		emit_signal("finished", "idle")

