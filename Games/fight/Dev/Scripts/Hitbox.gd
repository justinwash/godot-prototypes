extends Area2D

export(NodePath) var player_path
onready var player = get_node(player_path)
onready var collider := get_node("Collider")

export var active = false

func _ready():
	connect("area_entered", self, "collide")
	
func _physics_process(delta):
	collider.disabled = !active

func activate():
	set_collision_layer_bit(1 if player.PLAYER_ID == 1 else 2,true)
	set_collision_mask_bit(2 if player.PLAYER_ID == 1 else 1, true)
	collider.visible = true
	
func deactivate():
	set_collision_layer_bit(1 if player.PLAYER_ID == 1 else 2,false)
	set_collision_mask_bit(2 if player.PLAYER_ID == 1 else 1, false)
	collider.visible = false