extends Node

var mm_url
export var matchmaking_server_url = 'http://localhost'
export var matchmaking_server_port = ':3000'

var connect_endpoint = '/connect'
var info_endpoint = '/info'
var disconnect_endpoint = '/disconnect'
var ping_endpoint = '/ping'
var join_queue_endpoint = '/joinQueue'
var exit_queue_endpoint = '/exitQueue'
var get_queue_status_endpoint = '/getQueueStatus'

var server_port_forwarded = false
var server_port_retries = 3
var upnp = UPNP.new()
var SERVER_PORT = 42069

var _socket_server = WebSocketServer.new()
var _matchmaking_server_id

onready var _http = $HTTPRequest
onready var ping_timer = $PingTimer

onready var game = get_parent()

signal set_matchmaking_server_status
signal start_game

var player_id
var connected

func _ready():
	mm_url = matchmaking_server_url + matchmaking_server_port
	
	_forward_server_port()
	
	_connect_http_signals()
	_connect_lobby_signals()
	
	_make_connect_request()
	
func _forward_server_port():
	upnp.discover()
	while !server_port_forwarded and server_port_retries > 0:
		server_port_forwarded = upnp.add_port_mapping (SERVER_PORT, 0, '', 'TCP', 0) == 0
		print('server port forwarded? ', true if server_port_forwarded else false)
		if !server_port_forwarded:
			SERVER_PORT += 1
			server_port_retries -= 1
	if !server_port_forwarded:
		print('server port not forwarded via UPnP, trying to connect anyway.')

func _connect_http_signals():
	_http.connect("request_completed", self, "_on_request_completed")
	
func _connect_lobby_signals():
	game.connect("start_matching", self, "_start_matching_button_pressed")
	game.connect("cancel_matching", self, "_cancel_matching_button_pressed")
	game.connect("toggle_connection", self, "_toggle_connection_button_pressed")
	
func _make_connect_request():
	print("Attempting to connect to matchmaking server...")
	emit_signal("set_matchmaking_server_status", "Connecting to matchmaking server...", false)
	
	var lan_address
	for address in IP.get_local_addresses():
		if '192.168.1' in address:
			lan_address = address
	
	var server_port_param = '?serverPort=' + str(SERVER_PORT)
	var lan_address_param = ('&lanAddress=' + lan_address) if lan_address else ''
	var game_id_param = '&gameId=' + 'fps'

	_http.request(mm_url + connect_endpoint + server_port_param + lan_address_param + game_id_param)

func _make_info_request():
	var player_id_param = '?playerId=' + player_id
	_http.request(mm_url + info_endpoint + player_id_param)
	
func _make_disconnect_request():
	var player_id_param = '?playerId=' + player_id
	_http.request(mm_url + disconnect_endpoint + player_id_param)
	
func _make_ping_request():
	if connected:
		var player_id_param = '?playerId=' + player_id
		_http.request(mm_url + ping_endpoint + player_id_param)
	
func _make_join_queue_request():
	if connected:
		var player_id_param = '?playerId=' + player_id
		_http.request(mm_url + join_queue_endpoint + player_id_param)
	
func _make_exit_queue_request():
	if connected:
		var player_id_param = '?playerId=' + player_id
		_http.request(mm_url + exit_queue_endpoint + player_id_param)
		ping_timer.disconnect("timeout", self, "_make_get_queue_status_request")
		ping_timer.connect("timeout", self, "_make_ping_request")
		if ping_timer.is_stopped():
			ping_timer.start()
	
func _make_get_queue_status_request():
	var player_id_param = '?playerId=' + player_id
	_http.request(mm_url + get_queue_status_endpoint + player_id_param)
	
func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if !json.result:
		emit_signal("set_matchmaking_server_status", "Could not connect to matchmaking server.", false)
	else:
		var response = json.result
		print(response)
		
		match response.request:
			'connect':
				player_id = response.data.id
				connected = true
				emit_signal("set_matchmaking_server_status", "Connected to matchmaking server.", true)
				ping_timer.connect("timeout", self, "_make_ping_request")
				if ping_timer.is_stopped():
					ping_timer.start()
			'info':
				pass
			'disconnect':
				if response.success:
					emit_signal("set_matchmaking_server_status", "Disconnected from server", false)
					connected = false
					player_id = null
			'ping':
				if response.success:
					print('pong', response.data.timeout)
				else:
					connected = false
					player_id = null
					emit_signal("set_matchmaking_server_status", "Disconnected from server", false)
			'joinQueue':
				if response.success:
					emit_signal("set_matchmaking_server_status", "Searching for a match...", true)
					ping_timer.disconnect("timeout", self, "_make_ping_request")
					ping_timer.connect("timeout", self, "_make_get_queue_status_request")
					if ping_timer.is_stopped():
						ping_timer.start()
			'exitQueue':
				if response.success:
					emit_signal("set_matchmaking_server_status", "Canceled search", true)
			'getQueueStatus':
				if response.success:
					match response.message:
						'in queue':
							emit_signal("set_matchmaking_server_status", "Players in queue: " + str(response.data.playersInQueue), true)
						'match found':
							emit_signal("set_matchmaking_server_status", "Match found! Connecting... ", true)
							ping_timer.disconnect("timeout", self, "_make_get_queue_status_request")
							ping_timer.connect("timeout", self, "_make_ping_request")
							if ping_timer.is_stopped():
								ping_timer.start()
								
							# start server if hosting, client otherwise
							var match_data
							match_data.host = response.data.player.host
							match_data.should_serve_port = SERVER_PORT
							match_data.gateway_address = response.data.player.address
							emit_signal("start_game", match_data)
				else:
					_make_exit_queue_request()
					emit_signal("set_matchmaking_server_status", "Error finding match. Please Try again", false)

func _start_matching_button_pressed():
	_make_join_queue_request()
	
func _cancel_matching_button_pressed():
	_make_exit_queue_request()
		
func _toggle_connection_button_pressed():
	if connected:
		_make_disconnect_request()
	else:
		_make_connect_request()
		
