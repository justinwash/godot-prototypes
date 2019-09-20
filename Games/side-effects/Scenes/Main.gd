extends Node2D

export(NodePath) var box_path

var frame = 0

var enemy_types = [
	load("res://Scenes/RedEnemy.tscn"),
	load("res://Scenes/BlueEnemy.tscn"),
	load("res://Scenes/GreenEnemy.tscn"),
	load("res://Scenes/YellowEnemy.tscn")
]
	
var sides = ["top_right", "bottom_right", "bottom_left", "top_left"]

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	frame += 1
	
	if frame % 45 == 0:
		var enemy = enemy_types[get_random_number(4)].instance()
		enemy.spawn_side = sides[get_random_number(4)]
		enemy.box_reference = get_node(box_path)
		self.add_child(enemy)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func get_random_number(limit):
    randomize()
    return randi()%limit