extends "res://State.gd"

func update(delta):
	actor.move_and_slide(Vector2(0, 1000), Vector2(0, -1))

	print("idle")

	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		emit_signal("change_state", "walk")
