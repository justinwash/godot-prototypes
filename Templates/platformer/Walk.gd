extends "res://State.gd"

func update(delta):
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		actor.move_dir += 1
	if Input.is_action_pressed("move_left"):
		actor.move_dir -= 1

	actor.move_and_slide(Vector2(actor.move_dir * actor.MOVE_SPEED, actor.y_velo), Vector2(0, -1))

	var grounded = actor.is_on_floor()
	actor.y_velo += actor.GRAVITY

	if grounded and Input.is_action_just_pressed("jump"):
		emit_signal("change_state", "jump")

	if actor.facing_right and actor.move_dir < 0:
		actor.flip()
	if !actor.facing_right and actor.move_dir > 0:
		actor.flip()

	if grounded:
		if move_dir == 0:
			emit_signal("change_state", "idle")

	print("walk")

func enter():
	.enter()
	actor.play_anim("walk")