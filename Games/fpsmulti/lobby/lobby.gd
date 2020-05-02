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
	
func _connect_panel_signals():
	if game.has_method("_start_matching"):
		var _start_matching = matchmaking_panel.connect("start_matching", game, "_start_matching")
	if game.has_method("_cancel_matching"):
		var _cancel_matching = matchmaking_panel.connect("cancel_matching", game, "_cancel_matching")
	
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
	
func show_lobby():
	get_tree().paused = true
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
