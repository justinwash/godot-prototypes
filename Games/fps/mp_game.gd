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
	
puppet func _player_created(id, player):
	print('player ', id, 'created node ', player)

puppet func _create_players(players):
	$Players.add_children(players)
	
func _player_connected(_id):
	if get_tree().is_network_server():
		print('player connected: ', _id)
		players.append(Player.new(_id, $Players, $Spawnpoints/Spawnpoint))
	
		var local_exists = false
		for player in players:
			if player.id == get_tree().get_network_unique_id():
				local_exists = true
		if !local_exists:
			players.append(Player.new(get_tree().get_network_unique_id(), $Players, $Spawnpoints/Spawnpoint2))
			
		rpc("_create_players", $Players.get_children())
			
class Player extends Node:
	var id
	var node
	
	func _init(id, players_node, spawn_point):
		id = id
		node = create_node(id, players_node, spawn_point)
	
	func create_node(id, players_node, spawn_point):
		var new_player = preload("res://player/Player.tscn").instance()
		new_player.set_network_master(id)
		new_player.translation = spawn_point.translation
		players_node.add_child(new_player)
		return new_player
	
	
	
	
