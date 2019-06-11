extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
onready var hitbox = owner.get_node("Hitbox")
onready var animation_player = owner.get_node("AnimationPlayer")
var animation_finished := false
var attack
var elapsed_frames = -1

func enter():
	find_attack(character.dpad_attack, character.btn_attack)
	if attack != null:
		animation_player.play(attack.ANIMATION)
		animation_finished = false
		print("Attacking")
		elapsed_frames = -1
	else:
		print("attack not found")

func find_attack(dpad, btn):
	var state := ''
	if character.is_on_floor():
		state = 'Crouching' if [1, 2, 3].has(dpad) else 'Standing'
	else:
		state = 'Jumping'

	attack = character.get_node('Attacks/' + state + '/' + str(dpad) + '/' + str(btn) + '/' + 'a')
	if attack == null:
		attack = character.get_node('Attacks/' + state + '/' + str(5) + '/' + str(btn) + '/' + 'a')
		dpad = 5
		if attack == null && len(str(btn)) > 1:
			attack = character.get_node('Attacks/' + state + '/' + str(5) + '/' + str(btn)[1] + '/' + 'a')
			btn = int(str(btn)[1])

	hitbox.CURRENT_ATTACK = attack
	character.flush_input_buffer()

	print(' ')
	print(attack)
	print(str(dpad) + str(btn))
	print(' ')

func handle_input(event):
	return .handle_input(event)

func update(delta):
	elapsed_frames += 1
	var temp_buffer = character.input_buffer
	hitbox.CURRENT_ATTACK = attack

	if character.is_on_floor():
		character.move_dir = 0

	character.y_velo += character.GRAVITY

	if character.y_velo > character.MAX_FALL_SPEED:
		character.y_velo = character.MAX_FALL_SPEED

	character.move_and_slide(Vector2(character.move_dir * character.JUMP_X_FORCE, character.y_velo), Vector2(0, -1))

	var buffered_btn = character.find_buffered_btn(temp_buffer, attack.FOLLOWUP_BTNS, attack.CANCEL)

	if buffered_btn != null && elapsed_frames >= attack.CANCEL && attack.CANCEL > 0:
		print(attack.get_node(str(buffered_btn)).NAME)
		attack = attack.get_node(str(buffered_btn))
		animation_player.stop()
		animation_player.play(attack.ANIMATION)

	if animation_finished && !character.is_on_floor():
		hitbox.CURRENT_ATTACK = null
		emit_signal("finished", "land")
	elif animation_finished:
		hitbox.CURRENT_ATTACK = null
		emit_signal("finished", "idle")


func _on_animation_finished(anim_name):
	animation_finished = true
