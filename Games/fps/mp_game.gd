extends Node

onready var spawnpoints = $Spawnpoints
onready var lobby = $Lobby

var players = []

func _ready():
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")
	var _matching_started = lobby.get_node("MatchMakingPanel").connect("matching_started", self, "_matching_started")
	var _matching_canceled = lobby.get_node("MatchMakingPanel").connect("matching_canceled", self, "_matching_canceled")
		
func _matching_started():
	for player in $Players.get_children():
		player.queue_free()
		
	spawn_local_player()
	lobby.visible = false

func _matching_canceled():
	for player in $Players.get_children():
		player.queue_free()
	
func _player_connected(_id):
	for player in $Players.get_children():
		if player.net_id == 0:
			player.set_network_master(get_tree().get_network_unique_id())
			
	print('player connected: ', _id)
	spawn_remote_player(_id)
	
#	if get_tree().has_network_peer() and get_tree().is_network_server():
#		var new_player = preload("res://player/Player.tscn").instance()
#		new_player.set_network_master(get_tree().get_network_connected_peers()[0])
#		new_player.translation = $Spawnpoints/Spawnpoint.translation
#		$Players.add_child(new_player)
#
#	if get_tree().has_network_peer():
#		var new_player = preload("res://player/Player.tscn").instance()
#		new_player.set_network_master(get_tree().get_network_unique_id())
#		new_player.translation = $Spawnpoints/Spawnpoint2.translation
#		$Players.add_child(new_player)
#
#	print("my unique id: ", get_tree().get_network_unique_id())
		
func spawn_local_player():
	var new_player = preload("res://player/Player.tscn").instance()
	new_player.translation = $Spawnpoints/Spawnpoint2.translation
	new_player.set_network_master(get_tree().get_network_unique_id())
	new_player.net_id = 0
	$Players.add_child(new_player)
	
func spawn_remote_player(id):
	var new_player = preload("res://player/Player.tscn").instance()
	new_player.set_network_master(id)
	new_player.translation = $Spawnpoints/Spawnpoint.translation
	new_player.net_id = id
	$Players.add_child(new_player)
