extends Node

const GAME_PORT = 42090

var enet

onready var world = get_node("../../World")

func _ready():
	_connect_networking_signals()
	_connect_world_signals()
	_start_server()
	
func _connect_networking_signals():
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_connected_ok")
	var _connection_failed = get_tree().connect("connection_failed", self, "_connected_fail")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _connect_world_signals():
	var _map_loaded = world.connect("map_loaded", self, "_map_loaded")
	
func _connected_fail():
	get_tree().set_network_peer(null)
	
func _player_connected(_id):
	print("player connected: ", _id)
	world.spawn_player(_id)
	world.spawn_player(get_tree().get_network_unique_id())
	
func _player_disconnected(_id):
	print("player disconnected: ", _id)
	
func _start_server():
	enet = NetworkedMultiplayerENet.new()
	enet.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = enet.create_server(GAME_PORT, 1)
	if err != OK:
		print("Couldn't start server on port " + str(GAME_PORT))
		return
	else:
		print("Server started on port " + str(GAME_PORT))
	
	get_tree().set_network_peer(enet)
	
	# there should be another layer here for choosing map,
	# rules, etc
	world.load_map("test")
	
func _map_loaded():
	print('map loaded on server')
