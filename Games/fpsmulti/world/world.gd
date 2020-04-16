extends Node

onready var players = $Players
onready var map = $Map

func _ready():
	_load_map('test')
	
func _load_map(map_name):
	map.replace_by(load("res://maps/" + map_name + '/' + map_name + '.tscn').instance().set_name("Map"))
	
