extends KinematicBody

const MOVE_SPEED = 8
const MOUSE_SENS = 0.075

onready var raycast = $RayCast
onready var anim = $AnimationPlayer
onready var camera = $Camera
onready var HUD = $HUD

var spawn_translation
var spawn_rotation

var kills = 0

func _ready():
	spawn_translation = translation
	spawn_rotation = rotation
	
	if get_tree().has_network_peer() and is_network_master():
		for hud_element in $HUD.get_children():
			hud_element.visible = true
	else:
		for hud_element in $HUD.get_children():
			hud_element.visible = false

func _input(event):
	if get_tree().has_network_peer() and is_network_master():
		if event is InputEventMouseMotion:
			rotation_degrees.y -= MOUSE_SENS * event.relative.x
			rotation_degrees.x -= MOUSE_SENS * event.relative.y

func _physics_process(delta):
	if get_tree().has_network_peer() and is_network_master():
		$Camera.current = true
		var move_vec = Vector3()
		if Input.is_action_pressed("move_forwards"):
			move_vec.z -= 1
		if Input.is_action_pressed("move_backwards"):
			move_vec.z += 1
		if Input.is_action_pressed("move_left"):
			move_vec.x -= 1
		if Input.is_action_pressed("move_right"):
			move_vec.x += 1
		move_vec = move_vec.normalized()
		move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
		var _velocity = move_and_collide(move_vec * MOVE_SPEED * delta)
	
		if Input.is_action_pressed("shoot"):
			anim.play("shoot")
			var coll = raycast.get_collider()
			if raycast.is_colliding() and coll.has_method("kill"):
				rpc("kill", coll.get_network_master())
				kills += 1
		
		if get_tree().has_network_peer():
			rpc_unreliable("set_pos", global_transform)
		
puppet func set_pos(p_pos):
	global_transform = p_pos

puppet func kill(id):
	if get_network_master() == id:
		translation = spawn_translation
		rotation = spawn_rotation
