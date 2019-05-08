extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)

# Movement
export var JUMP_X_FORCE := 600
export var JUMP_Y_FORCE := 1000

const GRAVITY := 50
const MAX_FALL_SPEED := 1000

var y_velo := 0
var move_dir := 0
var momentum := 1

var jumped := false

func enter():
	owner.get_node("AnimationPlayer").play("Jump")
	jumped = false
	print("Jumping")

func update(delta):
	var grounded = character.is_on_floor()
	
	if grounded && !jumped:
		move_dir = 0
		momentum = 1
		
		if [9].has(character.dpad_input):
			move_dir += 1
		elif [7].has(character.dpad_input):
			move_dir -= 1
		y_velo = -JUMP_Y_FORCE

	y_velo += GRAVITY
	
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
		
	character.move_and_slide(Vector2(move_dir * JUMP_X_FORCE * momentum, y_velo), Vector2(0, -1))
	jumped = true
	
	if jumped && character.is_on_floor():
		emit_signal("finished", "idle")