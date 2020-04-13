extends Node

onready var spawnpoints = $Spawnpoints
onready var lobby = $Lobby
onready var players = $Players

var player1
var player2

func _ready():
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_end_game")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_end_game")
	var _matching_started = lobby.get_node("MatchMakingPanel").connect("matching_started", self, "_matching_started")
	var _matching_canceled = lobby.get_node("MatchMakingPanel").connect("matching_canceled", self, "_end_game")
		
func _matching_started():
	# start waiting/training mode
	pass

func _matching_canceled():
	# end waiting/training mode
	pass

func _player_connected(_id):
	player1 = preload('res://player/player.tscn').instance()
	player1.spawn.translation = $Spawnpoints/Spawnpoint.translation
	player1.spawn.rotation = $Spawnpoints/Spawnpoint.rotation
	players.add_child(player1)
	
	player2 = preload('res://player/player.tscn').instance()
	player2.spawn.translation = $Spawnpoints/Spawnpoint2.translation
	player2.spawn.rotation = $Spawnpoints/Spawnpoint2.rotation
	if get_tree().has_network_peer() and get_tree().is_network_server():
		player2.set_network_master(_id)
	elif get_tree().has_network_peer():
		player2.set_network_master(get_tree().get_network_unique_id())
	players.add_child(player2)

func _end_game():
	for player in players.get_children():
		player.queue_free()
	
	lobby.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	
	
