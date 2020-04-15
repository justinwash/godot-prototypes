extends Node

const GAME_PORT = 42069

func _ready():
	_connect_networking_signals()
	
func _connect_networking_signals():
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_connected_to_server")
	var _connection_failed = get_tree().connect("connection_failed", self, "_connected_fail")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _connected_fail():
	get_tree().set_network_peer(null)
	
func _connected_to_server():
	print('connected to server')
	
func _player_connected(_id):
	print("player connected: ", _id)
	
func start_client(data):
	var ip = data.server_address
	if '::ffff:' in ip:
		ip = ip.substr(7) if ip.substr(7) != "::1" else get_node("../../Matchmaker").matchmaking_server_url
	if not ip.is_valid_ip_address():
		return

	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	host.create_client(ip, GAME_PORT)
	get_tree().set_network_peer(host)
