extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
onready var animation_player = owner.get_node("AnimationPlayer")
var animation_finished := false
var attack

func enter():
	find_attack(character.dpad_attack, character.btn_attack)
	if attack != null:
		animation_player.play(attack.ANIMATION)
		animation_finished = false
		print("Attacking")
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



	print(' ')
	print(attack)
	print(str(dpad) + str(btn))
	print(' ')

func handle_input(event):
	return .handle_input(event)

func update(delta):

	if character.is_on_floor():
		character.move_dir = 0

	character.y_velo += character.GRAVITY

	if character.y_velo > character.MAX_FALL_SPEED:
		character.y_velo = character.MAX_FALL_SPEED

	character.move_and_slide(Vector2(character.move_dir * character.JUMP_X_FORCE, character.y_velo), Vector2(0, -1))

	if animation_finished && !character.is_on_floor():
		emit_signal("finished", "land")
	elif animation_finished:
		emit_signal("finished", "idle")


func _on_animation_finished(anim_name):
	animation_finished = true
