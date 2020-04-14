extends Node

var enet

const GAME_PORT = 42069

func _ready():
	_connect_networking_signals()
	
func _connect_networking_signals():
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_connected_ok")
	var _connection_failed = get_tree().connect("connection_failed", self, "_connected_fail")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _connected_fail():
	get_tree().set_network_peer(null)
	
func _temp(data):
	if data.player.host:
		enet = NetworkedMultiplayerENet.new()
		enet.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
		var err = enet.create_server(GAME_PORT, 1)
		if err != OK:
			print("Couldn't start server on port " + str(GAME_PORT))
			return
		else:
			print("Server started on port " + str(GAME_PORT))
	
		get_tree().set_network_peer(enet)
		emit_signal("server_started")
#
#	else:
#		var ip = data.opponent.address if data.opponent.address != '::1' else  matchmaking_server_url.substr(7)
#		if '::ffff:' in ip:
#			ip = ip.substr(7)
#		if not ip.is_valid_ip_address():
#			_set_status("IP address is invalid", false)
#			return
#
#		var host = NetworkedMultiplayerENet.new()
#		host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
#		host.create_client(ip, GAME_PORT)
#		get_tree().set_network_peer(host)
#
#		_set_status("Connecting...", true)
