extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
onready var hurtbox = character.get_node("Hurtbox")
onready var animation_player = owner.get_node("AnimationPlayer")
var animation_finished := false

var hit_by_local = null

func enter():
	animation_finished = false

	if hurtbox.HIT_BY != null:
		character.hitstun_remaining = hurtbox.HIT_BY.HITSTUN
		character.health -= hurtbox.HIT_BY.DAMAGE
		hit_by_local = hurtbox.HIT_BY

	elif hurtbox.COUNTERHIT_BY != null:
		character.hitstun_remaining = hurtbox.COUNTERHIT_BY.HITSTUN + hurtbox.COUNTERHIT_BY.COUNTER_HITSTUN
		character.health -= hurtbox.COUNTERHIT_BY.DAMAGE
		hit_by_local = hurtbox.COUNTERHIT_BY

		print(character.hitstun_remaining)
	character.state = "reel"
	play_animation()

func handle_input(event):
	return .handle_input(event)

func play_animation():
	animation_player.play("Idle")
	if hit_by_local.TYPE == "high":
		animation_player.play("Reel High")
	elif hit_by_local.TYPE == "mid":
		animation_player.play("Reel Mid")
	elif hit_by_local.TYPE == "low":
		animation_player.play("Reel Low")

func update(delta):
	var temp_buffer = character.input_buffer

	character.hitstun_remaining -= 1

	if (character.hitstun_remaining <= 0):
		hit_by_local = null
		hurtbox.HIT_BY = null
		hurtbox.COUNTERHIT_BY = null

	if character.is_on_floor():
		character.move_dir = 0

	character.y_velo += character.GRAVITY

	if character.y_velo > character.MAX_FALL_SPEED:
		character.y_velo = character.MAX_FALL_SPEED

	character.move_and_slide(Vector2(character.move_dir * character.JUMP_X_FORCE, character.y_velo), Vector2(0, -1))

	var buffered_btn = character.find_buffered_btn(temp_buffer, [1,2,3,4,12,13,14,23,24,34], 8)

	if (animation_finished || character.hitstun_remaining <= 0) && !character.is_on_floor():
		emit_signal("finished", "land")
	elif animation_finished || (buffered_btn != null && character.hitstun_remaining <= 0):
		character.dpad_attack = character.dpad_input
		character.btn_attack = 0 if buffered_btn == null else buffered_btn
		emit_signal("finished", "attack")
	elif animation_finished || ([1,2,3].has(character.dpad_input) && character.hitstun_remaining <= 0):
		emit_signal("finished", "crouch")
	elif animation_finished || (character.dpad_input != 5 && character.hitstun_remaining <= 0):
		emit_signal("finished", "move")
	elif animation_finished:
		emit_signal("finished", "idle")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name.find("Reel", 0) != -1:
		animation_finished = true
