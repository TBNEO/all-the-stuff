extends Node

enum STATES {
	BUILD,
	FISH
}

var state = STATES.FISH

func scroll_state():
	if state: 
		match state:
			STATES.BUILD:
				state = STATES.FISH
			STATES.FISH:
				state = STATES.BUILD
