extends Area2D

export(NodePath) var player_path
onready var player = get_node(player_path)
onready var collider := get_node("Collider")

export var COLLISION_LAYER_BIT := 1 if PLAYER_ID == 1 else 2
export var COLLISION_MASK_BIT := 2 if PLAYER_ID == 1 else 1

export var VISIBLE_IN_GAME := true

func _ready():
	connect("area_entered", self, "collide")

func activate():
	set_collision_layer_bit(COLLISION_LAYER_BIT,true)
	set_collision_mask_bit(COLLISION_MASK_BIT, true)
	collider.visible = true if VISIBLE_IN_GAME else false
	
func deactivate():
	set_collision_layer_bit(COLLISION_LAYER_BIT,false)
	set_collision_mask_bit(COLLISION_MASK_BIT, false)
	collider.visible = false

func collide(area):
	# call get_hit with the attack that owns 
	# the hitbox we collided with
	player.get_hit(area.get_parent())
	