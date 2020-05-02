extends Node

onready var lobby = $Lobby
onready var matchmaker = $Matchmaker
onready var networking_mode = $NetworkingMode

func _ready():
	_connect_matchmaking_signals()
	
func _connect_matchmaking_signals():
	matchmaker.connect("start_game", self, "_set_networking_mode")
	
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
