extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
onready var hurtbox = character.get_node("Hurtbox")
onready var animation_player = owner.get_node("AnimationPlayer")
var animation_finished := false

var hitstun_remaining = 0

func enter():
	animation_finished = false
	hitstun_remaining = hurtbox.HIT_BY.HITSTUN
	print(hitstun_remaining)
	play_animation()

func handle_input(event):
	return .handle_input(event)

func play_animation():
	animation_player.play("Idle")
	if hurtbox.HIT_BY.TYPE == "high":
		animation_player.play("Reel High")
	elif hurtbox.HIT_BY.TYPE == "mid":
		animation_player.play("Reel Mid")
	elif hurtbox.HIT_BY.TYPE == "low":
		animation_player.play("Reel Low")

func update(delta):
	hitstun_remaining -= 1
	print(hitstun_remaining)

	if character.is_on_floor():
		character.move_dir = 0

	character.y_velo += character.GRAVITY

	if character.y_velo > character.MAX_FALL_SPEED:
		character.y_velo = character.MAX_FALL_SPEED

	character.move_and_slide(Vector2(character.move_dir * character.JUMP_X_FORCE, character.y_velo), Vector2(0, -1))

	if (animation_finished || hitstun_remaining <= 0) && !character.is_on_floor():
		emit_signal("finished", "land")
	elif (animation_finished || hitstun_remaining <= 0):
		emit_signal("finished", "idle")


func _on_AnimationPlayer_animation_finished(anim_name):
	animation_finished = true


func _on_Hurtbox_area_entered(area):
	play_animation()
