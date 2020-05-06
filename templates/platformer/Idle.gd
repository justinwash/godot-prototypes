extends "res://State.gd"

func enter():
	.enter()
	print("idle")
	#actor.play_anim("idle")

func update(delta):
	actor.move_and_slide(Vector2(0, 1000), Vector2(0, -1))

	if Input.is_action_just_pressed("jump"):
		emit_signal("change_state", "jump")
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		emit_signal("change_state", "walk")


