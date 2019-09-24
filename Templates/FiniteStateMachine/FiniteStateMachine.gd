extends Node

export(NodePath) var START_STATE

var states = {
	# "example_state": $ExampleState	
}

var current_state = null

func _ready():
	for child in get_children():
        child.connect("change_state", self, "_change_state")
        
    current_state = get_node(START_STATE)
    current_state.enter()

func _physics_process(delta):
	current_state.update(delta)

func _change_state(state_name):
	current_state.exit()
	current_state = get_node(states[state_name])