extends Area2D

export(NodePath) var player_path
onready var player = get_node(player_path)
onready var collider := get_node("Collider")

#export var COLLISION_LAYER_BIT := 1 # if PLAYER_ID == 1 else 2
#export var COLLISION_MASK_BIT := 2 # if PLAYER_ID == 1 else 1

export var VISIBLE_IN_GAME := true

func _ready():
#	COLLISION_LAYER_BIT = 1 if player.PLAYER_ID == 1 else 2
#	COLLISION_MASK_BIT = 3 if player.PLAYER_ID == 1 else 4
	connect("area_entered", self, "collide")

func activate():
	set_collision_layer_bit(1 if player.PLAYER_ID == 1 else 2,true)
	set_collision_mask_bit(2 if player.PLAYER_ID == 1 else 1, true)
	collider.visible = true if VISIBLE_IN_GAME else false
	
func deactivate():
	set_collision_layer_bit(1 if player.PLAYER_ID == 1 else 2,false)
	set_collision_mask_bit(2 if player.PLAYER_ID == 1 else 1, false)
	collider.visible = false

func collide(area):
	# call get_hit with the attack that owns 
	# the hitbox we collided with
	# player.get_hit(area.get_parent())
	print("Colliding!" + str(area))
	