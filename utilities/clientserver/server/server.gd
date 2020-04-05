extends Node

const PORT = 42069
const MAX_PLAYERS = 8

const connections = []

func _ready():
	var server = NetworkedMultiplayerENet.new()
	server.create_server(PORT, MAX_PLAYERS)
	get_tree().set_network_peer(server)
	
	get_tree().connect("network_peer_connected", self, "_client_connected")
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")
	
	print("Server runnng on " + str(PORT))

func _client_connected(id):
	print("Client " + str(id) + " connected.")

func _client_disconnected(id):
	print("Client " + str(id) + " disconnected.")
