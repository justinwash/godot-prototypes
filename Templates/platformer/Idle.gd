extends "res://State.gd"

func update(delta):
	actor.move_and_slide(Vector2(0, 1000), Vector2(0, -1))
