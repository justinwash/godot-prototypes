extends Node

var enet

const GAME_PORT = 42069

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
