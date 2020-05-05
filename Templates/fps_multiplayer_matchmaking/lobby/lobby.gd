extends Control

onready var matchmaking_panel = $MatchMakingPanel
onready var player_panel = $PlayerPanel
onready var ready_panel = $ReadyPanel

onready var game = get_parent()

func _ready():
	_connect_game_signals()
	_connect_panel_signals()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _connect_game_signals():
	var _map_loaded = game.connect("map_loaded", self, "_map_loaded")
	var _set_matchmaking_server_status = game.connect("set_matchmaking_server_status", matchmaking_panel, "_set_matchmaking_server_status")
	var _left_game = game.connect("left_game", self, "_left_game")
	
func _connect_panel_signals():
	if game.has_method("_start_matching"):
		var _start_matching = matchmaking_panel.connect("start_matching", game, "_start_matching")
	if game.has_method("_cancel_matching"):
		var _cancel_matching = matchmaking_panel.connect("cancel_matching", game, "_cancel_matching")
	if game.has_method("_toggle_connection"):
		var _toggle_connection = matchmaking_panel.connect("toggle_connection", game, "_toggle_connection")
	if game.has_method("_start_practice"):
		var _toggle_connection = matchmaking_panel.connect("start_practice", game, "_start_practice")
	if game.has_method("_leave_game"):
		var _toggle_connection = matchmaking_panel.connect("leave_game", game, "_leave_game")
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = !visible
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  
		else: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
func _map_loaded():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	matchmaking_panel.cancel_button.text = "Leave Game"
	
func _left_game():
	matchmaking_panel.cancel_button.text = "Cancel"
	
func show_lobby():
	get_tree().paused = true
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
