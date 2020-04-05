extends Panel

var t = 0

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

func _player_connected(id):
	$Player2Label.text = "" + str(id) if id != 1 else "Host"
	
func _player_disconnected(id):
	$Player2Label.text = ""
