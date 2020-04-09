extends Control

const DEFAULT_PORT = 42069

onready var address = $Address
onready var host_button = $HostButton
onready var join_button = $JoinButton
onready var status_ok = $StatusOk
onready var status_fail = $StatusFail

func _ready():
	if !owner.online:
		host_button.set_disabled(true)
		join_button.set_disabled(true)
		_set_status("Offline", false)
		return

func _player_connected(_id):
	_set_status("Player joined: id " + str(_id), true)

func _player_disconnected(_id):
	host_button.set_disabled(false)
	join_button.set_disabled(false)
	
	_set_status("Player " + str(_id) + " disconnected", false)

func _connected_ok():
	_set_status("Connected", true)

func _connected_fail():
	_set_status("Couldn't connect", false)
	
	get_tree().set_network_peer(null)
	
	host_button.set_disabled(false)
	join_button.set_disabled(false)

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
	pass # Replace with function body.

func _on_CancelButton_pressed():
	pass # Replace with function body.
