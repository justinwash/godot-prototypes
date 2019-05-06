extends Area2D

export(NodePath) var player_path
onready var player = get_node(player_path)
onready var collider := get_node("Collider")
onready var anim_player := player.get_node("AnimationPlayer")

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

func collide():
	# check if we're blocking
	player.halt = true
	anim_player.play()
	# apply blockstun/hitstun
	# apply damage
	# apply knockback
	# 
	pass