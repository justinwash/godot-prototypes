extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)

# Movement
export var MOVE_SPEED := 300
var move_dir := 0
var momentum := 6
var max_distance = 1280

var has_dashed := false

func enter():
	momentum = 6
	owner.get_node("AnimationPlayer").play("Dash Forward")
	owner.flush_input_buffer()
	print("Dashing")

func handle_input(event):
	pass

func update(delta):
	var grounded = character.is_on_floor()

#	if grounded:
#		move_dir = 0
#		var opponent_distance = character.position.x - character.opponent.position.x
#
#		if opponent_distance > 0 && move_dir > 0:
#			if opponent_distance + move_dir > 900:
#				move_dir = 0
#
#		if opponent_distance < 0 && move_dir < 0:
#			if abs(opponent_distance + move_dir) > 900:
#				move_dir = 0
	if momentum <= 1:
		momentum = 1
	character.move_and_slide(Vector2(1 * MOVE_SPEED * momentum, 1000), Vector2(0, -1))
	momentum -= 1

func _on_animation_finished(anim_name):
	emit_signal("finished", "idle")
