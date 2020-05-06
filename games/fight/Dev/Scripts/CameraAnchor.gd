extends Node2D

export(NodePath) var CHARACTER_L
export(NodePath) var CHARACTER_R

var c1
var c2

func _ready():
	c1 = get_node(CHARACTER_L)
	c2 = get_node(CHARACTER_R)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	center_camera()

func center_camera():
	var x = 0
	var c1_x = c1.position.x
	var c2_x = c2.position.x
	x = (c1_x + c2_x) / 2
	position = Vector2(x,0)
