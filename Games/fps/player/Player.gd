extends Spatial

onready var status = $Status

var spawn = {
	translation: Vector3(0,0,0),
	rotation: Vector3(0,0,0)
}

func _ready():
	var new_mover = preload('res://player/mover.tscn').instance()
	new_mover.translation = spawn.translation
	new_mover.rotation = spawn.rotation
	$Mover.replace_by(new_mover)
	
	if get_network_master() == get_tree().get_network_unique_id():
			$Mover.camera.current = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _respawn():
	var new_mover = preload('res://player/mover.tscn').instance()
	new_mover.translation = spawn.translation
	new_mover.rotation = spawn.rotation
	$Mover.replace_by(new_mover)
	if get_network_master() == get_tree().get_network_unique_id():
			$Mover.camera.current = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
