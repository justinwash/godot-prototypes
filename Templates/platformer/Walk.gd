extends "res://State.gd"

func update(delta):
	if Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left"):
		actor.move_dir = 1
	elif Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
		actor.move_dir = -1
	else:
		actor.move_dir = 0

	actor.move_and_slide(Vector2(actor.move_dir * actor.MOVE_SPEED, actor.y_velo), Vector2(0, -1))

	var grounded = actor.is_on_floor()
	actor.y_velo += actor.GRAVITY

	if grounded and Input.is_action_just_pressed("jump"):
		emit_signal("change_state", "jump")

	if actor.facing_right and actor.move_dir < 0:
		actor.flip()
	if !actor.facing_right and actor.move_dir > 0:
		actor.flip()

	if actor.move_dir == 0:
		emit_signal("change_state", "idle")



func enter():
	.enter()
	print("walk")
	actor.play_anim("walk")