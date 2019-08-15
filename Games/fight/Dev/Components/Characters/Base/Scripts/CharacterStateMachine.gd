extends "../Scripts/States/StateMachine.gd"

# Instance
export(NodePath) var CHARACTER_PATH
onready var character = get_node(CHARACTER_PATH)
onready var hurtbox = owner.get_node("Hurtbox")

onready var high_mid_block_dpad = [4] if character.PLAYER_ID == 1 else [6]
onready var low_block_dpad = [1] if character.PLAYER_ID == 1 else [3]
onready var no_block_states = ["jump", "attack", "land", "dash"]

func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"crouch": $Crouch,
		"stand": $Stand,
		"jump": $Jump,
		"land": $Land,
		"attack": $Attack,
		"reel": $Reel,
		"block": $Block,
		"dash_forward": $DashForward,
		"dash_backward": $DashBackward,
		"grab": $Grab
	}

func _change_state(state_name):
	._change_state(state_name)

func _on_Hurtbox_area_entered(area):
	if character.state == "crouch" && area.CURRENT_ATTACK.TYPE == "high":
		return

		# get rid of the above that's some lazy shit dude

	elif character.attack_state == "startup":
		hurtbox.COUNTERHIT_BY = area.CURRENT_ATTACK
		character.set_attack_state(null)
		print("Counterhit by " + str(hurtbox.COUNTERHIT_BY))
		_change_state("reel")

	elif no_block_states.has(character.state):
		hurtbox.HIT_BY = area.CURRENT_ATTACK
		print("Hit by " + str(hurtbox.HIT_BY))
		_change_state("reel")

	elif character.hitstun_remaining == 0 && high_mid_block_dpad.has(character.dpad_input) && (area.CURRENT_ATTACK.TYPE == "high" || area.CURRENT_ATTACK.TYPE == "mid"):
		hurtbox.HIT_BY = area.CURRENT_ATTACK
		print("Blocked " + str(hurtbox.HIT_BY))
		_change_state("block")

	elif character.hitstun_remaining == 0 && low_block_dpad.has(character.dpad_input) && (area.CURRENT_ATTACK.TYPE == "low"):
		hurtbox.HIT_BY = area.CURRENT_ATTACK
		print("Blocked " + str(hurtbox.HIT_BY))
		_change_state("block")

	else:
		hurtbox.HIT_BY = area.CURRENT_ATTACK
		print("Hit by " + str(hurtbox.HIT_BY))
		_change_state("reel")
