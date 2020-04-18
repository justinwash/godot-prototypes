extends Node

export(NodePath) var ACTOR
export(NodePath) var START_STATE

var states = {
	"init": $Init
}

var current_state = null
var actor = null

func _ready():
	for child in get_children():
		child.connect("change_state", self, "_change_state")

	actor = get_node(ACTOR)

	current_state = get_node(START_STATE)
	if current_state.has_method("ready"):
		current_state.ready(actor)
	current_state.enter(actor)

func _physics_process(delta):
	current_state.update(actor)

func _change_state(state_name):
	current_state.exit()
	current_state = states[state_name]
	if current_state.has_method("ready"):
		current_state.ready(actor)
	current_state.enter(actor)
