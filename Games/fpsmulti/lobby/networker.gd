extends Node

export var matchmaking_server_url = 'http://localhost'
export var matchmaking_server_port = ':3000'

const GAME_PORT = 42069
const SOCKET_PORT = 1414

var _socket_server = WebSocketServer.new()

func _ready():	
	_connect_server_signals()
	_connect_websocket_signals()
	_start_websocket_server()

func _connect_server_signals():
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_connected_ok")
	var _connection_failed = get_tree().connect("connection_failed", self, "_connected_fail")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _connect_websocket_signals():
	_socket_server.connect("client_connected", self, "_socket_client_connected")
	_socket_server.connect("client_disconnected", self, "_socket_client_disconnected")
	_socket_server.connect("client_close_request", self, "_socket_close_request")
	_socket_server.connect("data_received", self, "_socket_on_data")
	
func _start_websocket_server():
	var err = _socket_server.listen(SOCKET_PORT)
	if err != OK:
		err = _socket_server.listen(SOCKET_PORT + 1)
		if err != OK:
			print("Unable to start server: both sockets in use")
		else:
			print('Websocket server started on port ', SOCKET_PORT +1)
	else:
		print('Websocket server started on port ', SOCKET_PORT)
	
			
func _player_connected(_id):
	pass

func _player_disconnected(_id):
	pass

func _connected_ok():
	pass

func _connected_fail():
	get_tree().set_network_peer(null)

func _server_disconnected():
	pass

func _make_get_request(route):
	 $HTTPRequest.request(matchmaking_server_url + matchmaking_server_port + route)

func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	
func _process(_delta):
	_socket_server.poll()
	
func _socket_client_connected(arg1, arg2):
	print("socket connected: ", arg1, arg2)
	
func _socket_on_data(id):
	var pkt = _socket_server.get_peer(id).get_packet()
	var data = parse_json(pkt.get_string_from_utf8()).data
	print("Got data from matchmaking server", data)
