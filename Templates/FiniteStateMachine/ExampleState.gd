extends "res://State.gd"

func enter():
	.enter()

	print("entering example state")

func update(delta):
	actor.move_and_slide(Vector2(0, 1000), Vector2(0, -1))