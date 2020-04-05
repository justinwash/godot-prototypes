extends Panel

var t = 0

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

func _player_connected(id):
	$Player2Label.text = "Player 2: " + str(id)
	
func _player_disconnected(id):
	$Player2Label.text = ""
