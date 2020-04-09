extends Node

onready var spawnpoints = $Spawnpoints

func _ready():
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")
		
func _player_connected(_id):
	if get_tree().has_network_peer() and get_tree().is_network_server():
		var new_player = preload("res://player/Player.tscn").instance()
		new_player.set_network_master(get_tree().get_network_connected_peers()[0])
		new_player.translation = $Spawnpoints/Spawnpoint.translation
		$Players.add_child(new_player)
		
	elif get_tree().has_network_peer():
		var new_player = preload("res://player/Player.tscn").instance()
		new_player.set_network_master(get_tree().get_network_unique_id())
		new_player.translation = $Spawnpoints/Spawnpoint.translation
		$Players.add_child(new_player)
	
	print("my unique id: ", get_tree().get_network_unique_id())
		
#func _player_disconnected(_id):
#	player2.queue_free()
#
#func _server_disconnected(_id):
#	player1.queue_free()
