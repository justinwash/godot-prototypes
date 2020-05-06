extends "res://FiniteStateMachine.gd"

func _ready():
	states = {
		"idle": $Idle,
		"walk": $Walk
	}