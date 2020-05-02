extends Node

onready var matchmaker = $Matchmaker
onready var lobby = $Lobby
onready var networking_mode = $NetworkingMode
onready var world = $World

# relay signals, for bridging communication between child nodes
signal map_loaded
signal start_matching
signal cancel_matching
signal set_matchmaking_server_status

func _ready():
	_connect_matchmaking_signals()
	_connect_world_signals()

func _connect_matchmaking_signals():
	matchmaker.connect("start_game", self, "_set_networking_mode")
	matchmaker.connect("set_matchmaking_server_status", self, "_set_matchmaking_server_status")
	
func _connect_world_signals():
	world.connect("map_loaded", self, "_map_loaded")
	
func _set_networking_mode(data):
	if data.networking_mode == 'server':
		var server = load("res://server/server.tscn").instance()
		server.GAME_PORT = int(data.should_serve_port)
		networking_mode.add_child(server)
	elif data.networking_mode == 'client':
		var client = load("res://client/client.tscn").instance()
		networking_mode.add_child(client)
		client.start_client(data)
		
	else:
		print("invalid networking mode")
		
# relay functions: these simply move signals from one child to another
func _map_loaded():
	emit_signal("map_loaded")
	
func _start_matching():
	print('start matching')
	emit_signal("start_matching")
	
func _cancel_matching():
	emit_signal("cancel_matching")
	
func _set_matchmaking_server_status(status, isok):
	emit_signal("set_matchmaking_server_status", status, isok)
