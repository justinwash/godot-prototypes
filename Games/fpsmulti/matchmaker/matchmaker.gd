extends Node

export var matchmaking_server_url = 'http://localhost'
export var matchmaking_server_port = ':3000'

var socket_port_forwarded = false
var server_port_forwarded = false
var upnp = UPNP.new()
var SOCKET_PORT = 1415
var SERVER_PORT = 42069

var _socket_server = WebSocketServer.new()
var _matchmaking_server_id

onready var _http = $HTTPRequest
onready var lobby = get_node("../Lobby")

signal matchmaking_server_status
signal start_game

func _ready():
	_forward_server_port()
	_connect_websocket_signals()
	_start_websocket_server()
	_connect_http_signals()
	_connect_to_matchmaking_server()
	_connect_node_signals()

func _connect_websocket_signals():
	_socket_server.connect("client_connected", self, "_socket_client_connected")
	_socket_server.connect("client_disconnected", self, "_socket_client_disconnected")
	_socket_server.connect("client_close_request", self, "_socket_close_request")
	_socket_server.connect("data_received", self, "_socket_on_data")
	
func _forward_server_port():
	upnp.discover()
	while !server_port_forwarded:
		server_port_forwarded = upnp.add_port_mapping (SERVER_PORT, 0, '', 'TCP', 0) == 0
		print('server port forwarded? ', true if server_port_forwarded else false)
		if !server_port_forwarded:
			SERVER_PORT += 1
	
func _forward_socket_port():
	upnp.discover()
	while !socket_port_forwarded:
		socket_port_forwarded = upnp.add_port_mapping (SOCKET_PORT, 0, '', 'TCP', 0) == 0
		print('socket port forwarded? ', true if socket_port_forwarded else false)
		if !socket_port_forwarded:
			SOCKET_PORT += 1
		
func _start_websocket_server():
	_forward_socket_port()
	
	while(!socket_port_forwarded):
		null
	
	var err = _socket_server.listen(SOCKET_PORT)
	if err != OK:
		print("Unable to start websocket server: ", err)
	else:
		print('Matchmaking listener server started on port ', SOCKET_PORT)

func _connect_http_signals():
	_http.connect("request_completed", self, "_on_request_completed")
	
func _connect_node_signals():
	lobby.matchmaking_panel.connect("start_matching", self, "_start_matching")
	lobby.matchmaking_panel.connect("cancel_matching", self, "_cancel_matching")
	
func _connect_to_matchmaking_server():
	print("Attempting to connect to matchmaking server...")
	emit_signal("matchmaking_server_status", "Connecting to matchmaking server...", false)
	
	var lan_address
	for address in IP.get_local_addresses():
		if '192.168.1' in address:
			lan_address = address
			
	_http.request(matchmaking_server_url + matchmaking_server_port + '/connect?socketPort=' + str(SOCKET_PORT) + '&serverPort=' + str(SERVER_PORT) + '&lanAddress=' + lan_address)

func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if !json.result or 'connect failed' in json.result:
		emit_signal("matchmaking_server_status", "Could not connect to matchmaking server.", false)
	else:
		emit_signal("matchmaking_server_status", "Connected to matchmaking server!", true)
	print("message from matchmaking server: ", "'", json.result, "'")
	
func _process(_delta):
	_socket_server.poll()
	
func _socket_client_connected(arg1, arg2):
	print("socket connected: ", arg1, arg2)
	
func _socket_on_data(id):
	_matchmaking_server_id = id
	var pkt = _socket_server.get_peer(id).get_packet()
	var message = parse_json(pkt.get_string_from_utf8())
	
	if message.type == 'confirmation':
		print("websocket data from matchmaking server: ", "'", message.data, "'")
		_socket_server.get_peer(id).put_packet('connected'.to_utf8())
		
	if message.type == 'start game':
		print("should start game in mode: ", "'", message.data.networking_mode, "'")
		message.data.should_serve_port = SERVER_PORT
		message.data.gateway_address = upnp.query_external_address()
		emit_signal("start_game", message.data)
		
		
func _socket_client_disconnected(_id, _data):
	emit_signal("matchmaking_server_status", "Lost connection to matchmaking server.", false)
	
func _start_matching():
	print('starting matchmaking')
	_socket_server.get_peer(_matchmaking_server_id).put_packet('start matching'.to_utf8())
	
func _cancel_matching():
	print('canceling matchmaking')
	_socket_server.get_peer(_matchmaking_server_id).put_packet('cancel matching'.to_utf8())
