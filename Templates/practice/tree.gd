extends RigidBody2D

onready var initial_y
export var MAX_Y_DISTANCE = 24

var top

func _ready():
	top = get_node("tree-top")
	initial_y = top.position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if top.position.y > initial_y + MAX_Y_DISTANCE:
		print(top.position.y)
		top.gravity_scale = 0
		top.linear_velocity = Vector2(0,0)
		top.angular_velocity = 0
		top.get_node("CollisionShape2D").disabled = true
		top.get_node("CollisionShape2D2").disabled = true


