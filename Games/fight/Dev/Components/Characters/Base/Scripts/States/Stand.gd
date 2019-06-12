extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
var animation_finished = false

func enter():
	owner.get_node("AnimationPlayer").play("Stand")
	character.state = "stand"
	print(str(character.PLAYER_ID) + " Standing")
	animation_finished = false

func handle_input(event):
	return .handle_input(event)

func update(delta):
	if character.btn_input != 0:
		character.dpad_attack = character.dpad_input
		character.btn_attack = character.btn_input
		emit_signal("finished", "attack")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name.find("Stand", 0) != -1:
		emit_signal("finished", "idle")
