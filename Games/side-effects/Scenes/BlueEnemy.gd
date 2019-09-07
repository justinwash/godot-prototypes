extends KinematicBody2D

export var spawn_side = "left"
export var move_speed = 200

var spawn_points
var destination
var vector
var box_reference
var type = "BlueEnemy"

func _ready():
	spawn_points = {
		"right": Vector2(box_reference.position.x + 1000, box_reference.position.y),
		"bottom": Vector2(box_reference.position.x + 1, box_reference.position.y + 1000),
		"left": Vector2(box_reference.position.x - 1000, box_reference.position.y + 1),
		"top": Vector2(box_reference.position.x + 1, box_reference.position.y - 1000),
	}
	
	self.position = spawn_points[spawn_side]
	destination = box_reference.position

func _physics_process(delta):
	vector = (destination - self.position).normalized()
	move_and_collide(vector * move_speed * delta)
	
	if self.position.distance_to(destination) < 10:
		self.free()