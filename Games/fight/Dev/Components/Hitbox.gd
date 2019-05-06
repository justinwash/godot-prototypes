extends Area2D

onready var player := get_parent().get_parent()
onready var collider := get_node("Collider")

func activate():
	collider.visible = true
	
func deactivate():
	collider.visible = false