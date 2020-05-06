extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
export(NodePath) var OPPONENT_PATH

onready var character = get_node(CHARACTER_PATH)
onready var opponent = get_node(OPPONENT_PATH)

onready var hitbox = owner.get_node("Hitbox")
onready var animation_player = owner.get_node("AnimationPlayer")

var animation_finished := false
var elapsed_frames = -1

func enter():
	animation_player.play("Grab")
	animation_finished = false
	hitbox.CURRENT_ATTACK = character.get_node("Attacks/Grabs/1")
	print("Grabbing")
	elapsed_frames = -1
	character.state = "grab"

func update(delta):
	elapsed_frames += 1

	if elapsed_frames >= 16 && opponent.state != "grabbed":
		animation_finished = true

	var temp_buffer = character.input_buffer

	character.move_and_slide(Vector2(character.move_dir, character.y_velo), Vector2(0, -1))

	if animation_finished && !character.is_on_floor():
		hitbox.CURRENT_ATTACK = null
		emit_signal("finished", "land")
	elif animation_finished:
		hitbox.CURRENT_ATTACK = null
		emit_signal("finished", "idle")


func _on_animation_finished(anim_name):
	animation_finished = true
