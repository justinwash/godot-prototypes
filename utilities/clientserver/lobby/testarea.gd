extends Node2D

func _ready():
	$TestMover2.speed = 0
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
		
func _player_connected(_id):
	if get_tree().is_network_server():
		$TestMover2.set_network_master(get_tree().get_network_connected_peers()[0])
		$TestMover2.speed = 200
	else:
		$TestMover2.set_network_master(get_tree().get_network_unique_id())
		
	print("my unique id: ", get_tree().get_network_unique_id())
		
func _player_disconnected(_id):
	$TestMover2.speed = 0
