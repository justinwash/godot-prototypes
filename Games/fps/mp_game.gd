extends Node

onready var player1 = $Player1
onready var player2 = $Player2

func _ready():
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")
		
func _player_connected(_id):
	if get_tree().has_network_peer() and get_tree().is_network_server():
		player2.set_network_master(get_tree().get_network_connected_peers()[0])
		
	elif get_tree().has_network_peer():
		player2.set_network_master(get_tree().get_network_unique_id())
	
	print("my unique id: ", get_tree().get_network_unique_id())
		
#func _player_disconnected(_id):
#	player2.queue_free()
#
#func _server_disconnected(_id):
#	player1.queue_free()
