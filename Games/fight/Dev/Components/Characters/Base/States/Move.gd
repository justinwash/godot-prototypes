extends "../../../../Scripts/State.gd"

# movement
export var MOVE_SPEED := 500
export var JUMP_X_MOMENTUM := 2
const JUMP_FORCE := 1000
const GRAVITY := 50
const MAX_FALL_SPEED := 1000

var y_velo := 0
var move_dir := 0
var momentum := 1

func update(delta):
	update_dpad()	
	update_btn()

	move()

	move_and_slide(Vector2(move_dir * MOVE_SPEED * momentum, y_velo), Vector2(0, -1))
	
func move():
	if busy == false:
		var grounded = is_on_floor()
	
		if grounded:
			move_dir = 0
			momentum = 1
		
			if dpad_input == 6 || dpad_input == 9:
				move_dir += 1
			elif dpad_input == 4 || dpad_input == 7:
				move_dir -= 1
	
		y_velo += GRAVITY
		if grounded && (dpad_input == 7 || dpad_input == 8 || dpad_input == 9):
			y_velo = -JUMP_FORCE
			momentum = JUMP_X_MOMENTUM
		
		if grounded and y_velo >= 0:
			y_velo = 5
		if y_velo > MAX_FALL_SPEED:
			y_velo = MAX_FALL_SPEED