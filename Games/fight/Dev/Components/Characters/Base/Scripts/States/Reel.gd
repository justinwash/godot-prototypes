extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
onready var hurtbox = character.get_node("Hurtbox")
onready var animation_player = owner.get_node("AnimationPlayer")
var animation_finished := false

var hit_by_local = null

var pushback := 0
var pushback_dir := 0
var pushback_speed := 0.0

func enter():
	animation_finished = false

	if hurtbox.HIT_BY != null:
		hit_by_local = hurtbox.HIT_BY
		if hurtbox.HIT_BY.IS_THROW:
			character.state = "grabbed"
			play_animation()
		else:
			character.hitstun_remaining = hurtbox.HIT_BY.HITSTUN
			character.health -= hurtbox.HIT_BY.DAMAGE
			hit_by_local = hurtbox.HIT_BY
			pushback = hit_by_local.PUSHBACK_OPP
			pushback_dir = hit_by_local.PUSHBACK_OPP_DIR * -1 if character.PLAYER_ID == 1 else 1
			pushback_speed = hit_by_local.PUSHBACK_OPP_SPEED
			character.state = "reel"
			play_animation()

	elif hurtbox.COUNTERHIT_BY != null:
		character.hitstun_remaining = hurtbox.COUNTERHIT_BY.HITSTUN + hurtbox.COUNTERHIT_BY.COUNTER_HITSTUN
		character.health -= hurtbox.COUNTERHIT_BY.DAMAGE
		hit_by_local = hurtbox.COUNTERHIT_BY
		pushback = hit_by_local.PUSHBACK_OPP
		pushback_dir = -1 if character.PLAYER_ID == 1 else 1
		pushback_speed = hit_by_local.PUSHBACK_OPP_SPEED
		character.state = "reel"
		play_animation()

func handle_input(event):
	return .handle_input(event)

func play_animation():
	animation_player.play("Idle")
	if hit_by_local.IS_THROW:
		animation_player.play("Grabbed")
	elif hit_by_local.TYPE == "high":
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
		character.move_dir = pushback_dir

	character.y_velo += character.GRAVITY

	if character.y_velo > character.MAX_FALL_SPEED:
		character.y_velo = character.MAX_FALL_SPEED

	character.move_and_slide(Vector2(character.move_dir * pushback * pushback_speed * character.JUMP_X_FORCE, character.y_velo), Vector2(0, -1))

	if pushback > 0:
		pushback -= 1

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
	character.state = "idle"
	if anim_name.find("Reel", 0) != -1:
		animation_finished = true
