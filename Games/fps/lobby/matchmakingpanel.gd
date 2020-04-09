extends Control

const DEFAULT_PORT = 42069
const matchmaking_server_url = 'http://192.168.1.183:3000'

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
	
func _make_get_request(route):
	 $HTTPRequest.request(matchmaking_server_url + route)
	
func _make_post_request(route, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(matchmaking_server_url + route, headers, use_ssl, HTTPClient.METHOD_POST, query)
	
func _make_delete_request(route, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(matchmaking_server_url + route, headers, use_ssl, HTTPClient.METHOD_DELETE, query)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
