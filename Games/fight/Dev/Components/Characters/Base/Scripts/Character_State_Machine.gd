extends "../Scripts/States/StateMachine.gd"

func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"crouch": $Crouch,
		"jump": $Jump
	}

func _change_state(state_name):
	._change_state(state_name)