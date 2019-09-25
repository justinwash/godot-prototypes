# Simple Finite State Machine

### To Use:

1) Create a StateMachine Node on your character/item/enemy/whatever.
2) Attach an empty script to the StateMachine Node and extend ```FiniteSateMachine.gd```. Assign the ```ACTOR``` property exposed in the editor to the Node the StateMachine should control e.g. ```Player```.
3) Add a Node as a child to your StateMachine Node.
4) Attach an empty script to the child Node and extend ```State.gd```.
5) Override the ```enter(), exit(),``` and ```update(delta)``` methods with your behaviors.
6) Add the state to the ```states``` object on the StateMachine Node e.g. ```"example_state": $ExampleState```.
7) Repeat for as many Nodes as you have states.

### State Switching:

* To switch from one state to another call ```emit_signal("change_state", "name_of_new_state")``` from somewhere in the ```update(delta)``` method on a State Node.
* To switch to a particular state regardless of the current one call ```_change_state("name_of_new_state")``` in ```_physics_process(delta)``` or a connected ```signal``` on the StateMachine Node. (This sort of defeats the purpose of a finite state machine though so I hope you know what you're doing!)
