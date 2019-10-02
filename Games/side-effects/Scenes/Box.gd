extends Node2D

onready var TweenNode = get_node("Tween")

# target to look at
var target = 0

var orientations

var counters

func _ready():
	orientations = [
		Vector2(self.position.x + 1000, self.position.y - 1000),
		Vector2(self.position.x + 1000, self.position.y + 1000),
		Vector2(self.position.x - 1000, self.position.y + 1000),
		Vector2(self.position.x - 1000, self.position.y - 1000),
	]

	counters = get_node("../Counters")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_left"):
		target = (target - 1) % 4
	if Input.is_action_just_pressed("ui_right"):
		target = abs((target + 1) % 4)

	# initial and final x-vector of basis
	var initial_transform_x = self.transform.x
	var final_transform_x = (orientations[target] - self.global_position).normalized()

	# interpolate
	TweenNode.interpolate_method(self, '_set_rotation', initial_transform_x, final_transform_x, 0.1, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	TweenNode.start()

# apply rotation
func _set_rotation(new_transform):

	# apply tweened x-vector of basis
	self.transform.x = new_transform

	# make x and y orthogonal and normalized
	self.transform = self.transform.orthonormalized()

func _on_RedSide_body_entered(body):
	if (body.type == "RedEnemy"):
		body.free()
		counters.reset_missed()
		counters.increment_caught()


func _on_GreenSide_body_entered(body):
	if (body.type == "GreenEnemy"):
		body.free()
		counters.reset_missed()
		counters.increment_caught()


func _on_BlueSide_body_entered(body):
	if (body.type == "BlueEnemy"):
		body.free()
		counters.reset_missed()
		counters.increment_caught()


func _on_YellowSide_body_entered(body):
	if (body.type == "YellowEnemy"):
		body.free()
		counters.reset_missed()
		counters.increment_caught()
