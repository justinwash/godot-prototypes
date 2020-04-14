extends Control

export (NodePath) var matchmaker_path
export (NodePath) var server_path
export (NodePath) var client_path

onready var matchmaking_panel = $MatchMakingPanel
onready var player_panel = $PlayerPanel
onready var ready_panel = $ReadyPanel


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = !visible
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  
		else: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
