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
	# start waiting/training mode
	pass

func _matching_canceled():
	# end waiting/training mode
	pass
	
func _player_connected(_id):
	print('player connected: ', _id)
	players.append(Player.new(_id))
	
	var local_exists = false
	for player in players:
		if player.id == get_tree().get_network_unique_id():
			local_exists = true
	if !local_exists:
		players.append(Player.new(get_tree().get_network_unique_id()))
			
#	for player in $Players.get_children():
#		player.queue_free()
#	spawn_remote_player(_id)
#	spawn_local_player()
#
#	for player in $Players.get_children():
#		if player.net_id == 0:
#			player.set_network_master(get_tree().get_network_unique_id())
#			player.get_node("Camera").current = true
	
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
	$Players.add_child(new_player)
	
func spawn_remote_player(id):
	var new_player = preload("res://player/Player.tscn").instance()
	new_player.set_network_master(id)
	new_player.translation = $Spawnpoints/Spawnpoint.translation
	$Players.add_child(new_player)
	
class Player extends Node:
	var id
	var node
	
	func _init(id):
		id = id
		node = create_node(id)
	
	func create_node(id):
		var new_player = preload("res://player/Player.tscn").instance()
		new_player.set_network_master(id)
		$Players.add_child(new_player)
		return new_player
	
	
	
	
