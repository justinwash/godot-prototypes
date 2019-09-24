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

	actor.move_and_slide(Vector2(0, actor.y_velo), Vector2(0,-1))