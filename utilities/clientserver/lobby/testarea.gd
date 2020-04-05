extends Node2D

var player1
var player2

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
		
func _player_connected(_id):
	player1 = preload('res://mover/mover.tscn').instance()
	player1.position = $SpawnPoints/Spawn.position
	player2 = preload('res://mover/mover.tscn').instance()
	player2.position = $SpawnPoints/Spawn2.position
	
	
	if get_tree().is_network_server():
		player2.set_network_master(get_tree().get_network_connected_peers()[0])
	else:
		player2.set_network_master(get_tree().get_network_unique_id())
		
	add_child(player1)
	add_child(player2)
	
	print("my unique id: ", get_tree().get_network_unique_id())
		
func _player_disconnected(_id):
	player2.free()
