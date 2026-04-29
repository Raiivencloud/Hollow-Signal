extends Node

## Hollow Signal - Moral Decision System
## Tracks choices that impact the game's ending and environment

var karma: float = 0.0 # -1.0 (Corrupted) to 1.0 (Pure)
var choices_made: Dictionary = {}

func make_choice(id: String, value: float):
	if choices_made.has(id): return
	
	choices_made[id] = value
	karma = clamp(karma + value, -1.0, 1.0)
	
	GameEvents.emit_signal("moral_choice_made", id, value)
	
	# Environmental impacts
	_apply_karma_to_world()

func _apply_karma_to_world():
	# Darker karma might lead to more frequent Stalker appearances
	# or shifted color grading (WorldEnvironment)
	if karma < -0.5:
		MentalSystem.add_anxiety(0.2)
