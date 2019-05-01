extends Node

export var HITBOX_X = 0
export var HITBOX_Y = 0
export var HITBOX_HEIGHT = 60
export var HITBOX_WIDTH = 100

var hitbox = Area2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.add_child(CollisionShape2D.new())
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
