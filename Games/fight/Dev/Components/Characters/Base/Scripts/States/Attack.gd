extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
onready var animation_player = owner.get_node("AnimationPlayer")
var animation_finished := false

func enter():
	animation_player.play("Punch")
	animation_finished = false
	print("Attacking")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	if animation_finished && !character.is_on_floor():
		emit_signal("finished", "jump")
	if animation_finished:
		emit_signal("finished", "idle")


func _on_animation_finished(anim_name):
	animation_finished = true
