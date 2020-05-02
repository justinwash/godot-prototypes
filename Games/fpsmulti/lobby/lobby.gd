extends Control

export (NodePath) var matchmaker_path

onready var matchmaking_panel = $MatchMakingPanel
onready var player_panel = $PlayerPanel
onready var ready_panel = $ReadyPanel

onready var world = get_node("../World")

func _ready():
	var _map_loaded = world.connect("map_loaded", self, "_map_loaded")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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
