extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
onready var hurtbox = character.get_node("Hurtbox")
onready var animation_player = owner.get_node("AnimationPlayer")
var animation_finished := false

var blockstun_remaining = 0

func enter():
	animation_finished = false
	blockstun_remaining = hurtbox.HIT_BY.BLOCKSTUN
	print(blockstun_remaining)
	character.state = "block"
	play_animation()

func handle_input(event):
	return .handle_input(event)

func play_animation():
	animation_player.play("Idle")
	if hurtbox.HIT_BY.TYPE == "high":
		animation_player.play("Block High")
	elif hurtbox.HIT_BY.TYPE == "mid":
		animation_player.play("Block Mid")
	elif hurtbox.HIT_BY.TYPE == "low":
		animation_player.play("Block Low")

func update(delta):
	var temp_buffer = character.input_buffer

	blockstun_remaining -= 1

	if character.is_on_floor():
		character.move_dir = 0

	character.y_velo += character.GRAVITY

	if character.y_velo > character.MAX_FALL_SPEED:
		character.y_velo = character.MAX_FALL_SPEED

	character.move_and_slide(Vector2(character.move_dir * character.JUMP_X_FORCE, character.y_velo), Vector2(0, -1))

	var buffered_btn = character.find_buffered_btn(temp_buffer, [1,2,3,4,12,13,14,23,24,34], 8)

	if (animation_finished || blockstun_remaining <= 0) && !character.is_on_floor():
		emit_signal("finished", "land")
	elif animation_finished || (buffered_btn != null && blockstun_remaining <= 0):
		character.dpad_attack = character.dpad_input
		character.btn_attack = 0 if buffered_btn == null else buffered_btn
		emit_signal("finished", "attack")
	elif animation_finished || ([1,2,3].has(character.dpad_input) && blockstun_remaining <= 0):
		emit_signal("finished", "crouch")
	elif animation_finished || (character.dpad_input != 5 && blockstun_remaining <= 0):
		emit_signal("finished", "move")
	elif animation_finished:
		emit_signal("finished", "idle")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name.find("Block", 0) != -1:
		animation_finished = true
