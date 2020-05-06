extends Node

# properties
export var NAME := "Punch"
export var ANIMATION := "Punch"
export var DAMAGE := 10
export var CANCEL := 0
export var TYPE := 'high'
export var TRAVEL := 0
export var TRAVEL_DIR := 0
export var TRAVEL_SPEED := 0.0
export var PUSHBACK_SELF := 0
export var PUSHBACK_OPP := 0
export var PUSHBACK_OPP_DIR := 0
export var PUSHBACK_OPP_SPEED := 0
export var IS_STRING := true
export var STRING_TRIM := 5
export var FOLLOWUP_BTNS := [1, 2]
export var IS_PARRY := false
export var IS_THROW := false
export var ARMOR := 0

# framedata
export var BLOCKSTUN := 7
export var HITSTUN := 12
export var COUNTER_HITSTUN := 4