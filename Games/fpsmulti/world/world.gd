extends Node

onready var players = $Players
var map

func _ready():
	pass
	
func load_map(map_name):
	map = load("res://maps/" + map_name + '/' + map_name + '.tscn').instance()
	map.name = "Map"
	add_child(map)
	
