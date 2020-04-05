extends "res://State.gd"

func enter():
	.enter()
	actor.y_velo = -actor.JUMP_FORCE
	actor.play_anim("jump")
	print("jump")

func update(delta):
	actor.y_velo += actor.GRAVITY
	if actor.is_on_floor() and actor.y_velo >= 0:
		emit_signal("change_state", "idle")
	if actor.y_velo > actor.MAX_FALL_SPEED:
		actor.y_velo = actor.MAX_FALL_SPEED

	if Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left"):
		actor.move_dir = 1
	elif Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
		actor.move_dir = -1
	else:
		actor.move_dir = 0

	actor.move_and_slide(Vector2(actor.move_dir * actor.MOVE_SPEED, actor.y_velo), Vector2(0,-1))