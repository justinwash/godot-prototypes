extends Control

export var online = true
export var matchmaking = true

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = false if online else !get_tree().paused
		visible = !visible
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  
		else: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_Cancel_pressed():
	pass # Replace with function body.
