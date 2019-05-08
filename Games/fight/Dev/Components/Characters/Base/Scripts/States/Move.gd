extends "State.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)

# Movement
export var MOVE_SPEED := 300
var move_dir := 0
var momentum := 1

func enter():
	owner.get_node("AnimationPlayer").play("Move")
	print("Moving")
	
# warning-ignore:unused_argument
func handle_input(event):
	pass

# warning-ignore:unused_argument
func update(delta):
	var grounded = character.is_on_floor()
	
	if grounded:
		move_dir = 0
		momentum = 1
		
		if [6, 9].has(character.dpad_input):
			move_dir += 1
		elif [4, 7].has(character.dpad_input):
			move_dir -= 1
		
	character.move_and_slide(Vector2(move_dir * MOVE_SPEED * momentum, 1000), Vector2(0, -1))
	
	if ![4, 6].has(character.dpad_input) && grounded:
		emit_signal("finished", "idle")