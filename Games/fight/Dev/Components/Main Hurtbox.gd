extends Area2D

export(NodePath) var player_path
onready var player = get_node(player_path)
onready var collider := get_node("Collider")

export var VISIBLE_IN_GAME := true

func _ready():
	set_collision_layer_bit(1 if player.PLAYER_ID == 1 else 2,true)
	connect("area_entered", self, "collide")

func collide(area):
	# call get_hit with the attack that owns 
	# the hitbox we collided with
	player.get_hit(area.get_parent())
	