extends "../Scripts/States/StateMachine.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
onready var hurtbox = owner.get_node("Hurtbox")

func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"crouch": $Crouch,
		"jump": $Jump,
		"land": $Land,
		"attack": $Attack,
		"reel": $Reel
	}

func _change_state(state_name):
	._change_state(state_name)

func _on_Hurtbox_area_entered(area):
	hurtbox.HIT_BY = area.CURRENT_ATTACK
	print("Hit by " + str(hurtbox.HIT_BY))
	_change_state("reel")
