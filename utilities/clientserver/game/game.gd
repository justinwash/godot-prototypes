extends Node

export var HOSTING = true

func _ready():
	if HOSTING:
		$server.replace_by(load('res://server/server.tscn').instance())
