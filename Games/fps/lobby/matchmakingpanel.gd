extends Control

const GAME_PORT = 42069
const SOCKET_PORT = 1414
export var matchmaking_server_url = 'http://localhost'
export var matchmaking_server_port = ':3000'
var _socket_server = WebSocketServer.new()
var enet

onready var status_ok = $StatusOk
onready var status_fail = $StatusFail

func _ready():
	if !owner.online:
		_set_status("Offline", false)
		return
		
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_connected_ok")
	var _connection_failed = get_tree().connect("connection_failed", self, "_connected_fail")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	_socket_server.connect("client_connected", self, "_socket_client_connected")
	_socket_server.connect("client_disconnected", self, "_socket_client_disconnected")
	_socket_server.connect("client_close_request", self, "_socket_close_request")
	_socket_server.connect("data_received", self, "_socket_on_data")
	var err = _socket_server.listen(SOCKET_PORT)
	if err != OK:
		print("Unable to start server")
		set_process(false)
	
	
func _player_connected(_id):
	_set_status("Player joined: id " + str(_id), true)

func _player_disconnected(_id):
	_set_status("Player " + str(_id) + " disconnected", false)

func _connected_ok():
	_set_status("Connected", true)

func _connected_fail():
	_set_status("Couldn't connect", false)
	
	get_tree().set_network_peer(null)

func _server_disconnected():
	_set_status("Server disconnected", false)

func _set_status(text, isok):
	if isok:
		status_ok.set_text(text)
		status_fail.set_text("")
	else:
		status_ok.set_text("")
		status_fail.set_text(text)

func _on_FindButton_pressed():
	_make_post_request('/queue', null, false)

func _on_CancelButton_pressed():
	_make_delete_request('/queue', null, false)
	get_tree().set_network_peer(null)
	enet = null
	_set_status("", false)
	
	
func _make_get_request(route):
	 $HTTPRequest.request(matchmaking_server_url + matchmaking_server_port + route)
	
func _make_post_request(route, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(matchmaking_server_url + matchmaking_server_port + route, headers, use_ssl, HTTPClient.METHOD_POST, query)
	
func _make_delete_request(route, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(matchmaking_server_url + matchmaking_server_port + route, headers, use_ssl, HTTPClient.METHOD_DELETE, query)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	
func _process(_delta):
	_socket_server.poll()
	
func _socket_on_data(id):
	var pkt = _socket_server.get_peer(id).get_packet()
	var data = parse_json(pkt.get_string_from_utf8()).data
	print("Got data from matchmaking server", data)
	
	if data.player.host:
		enet = NetworkedMultiplayerENet.new()
		enet.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
		var err = enet.create_server(GAME_PORT, 1)
		if err != OK:
			_set_status("Can't host, address in use.",false)
			return
		else:
			print("Server started on port " + str(GAME_PORT))
	
		get_tree().set_network_peer(enet)
		_set_status("Waiting for player...", true)
		
	else:
		var ip = data.opponent.address if data.opponent.address != '::1' else  matchmaking_server_url.substr(7)
		if '::ffff:' in ip:
			ip = ip.substr(7)
		if not ip.is_valid_ip_address():
			_set_status("IP address is invalid", false)
			return
	
		var host = NetworkedMultiplayerENet.new()
		host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
		host.create_client(ip, GAME_PORT)
		get_tree().set_network_peer(host)
	
		_set_status("Connecting...", true)
