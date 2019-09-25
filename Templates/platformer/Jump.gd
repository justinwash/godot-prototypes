extends "res://State.gd"

func enter():
	.enter()
	actor.y_velo = -actor.JUMP_FORCE

	print("jump")

func update(delta):
	actor.y_velo += actor.GRAVITY
	if actor.is_on_floor() and actor.y_velo >= 0:
		emit_signal("change_state", "idle")
	if actor.y_velo > actor.MAX_FALL_SPEED:
		actor.y_velo = actor.MAX_FALL_SPEED
