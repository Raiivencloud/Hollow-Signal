extends Node

## Hollow Signal - Mental State System
## Manages Anxiety and Paranoia variables and their cascading effects

@export var anxiety_decay: float = 0.05
@export var paranoia_growth_multiplier: float = 1.0

var anxiety: float = 0.0 : set = _set_anxiety
var paranoia: float = 0.0 : set = _set_paranoia

func _process(delta):
	# Slowly reduce anxiety if not in a high-tension situation
	# This avoids permanent max anxiety unless sustained by events
	if anxiety > 0:
		_set_anxiety(anxiety - (anxiety_decay * delta))

func _set_anxiety(val: float):
	anxiety = clamp(val, 0.0, 1.0)
	GameEvents.emit_signal("anxiety_level_changed", anxiety)
	_apply_threshold_effects()

func _set_paranoia(val: float):
	paranoia = clamp(val, 0.0, 1.0)
	GameEvents.emit_signal("paranoia_level_changed", paranoia)

func add_anxiety(amount: float):
	_set_anxiety(anxiety + amount)

func _apply_threshold_effects():
	# Visual/Audio feedback based on state
	var saturation = 1.0 - (anxiety * 0.5) # Desaturate as anxiety grows
	var tint = Color(1.0, 1.0 - (anxiety * 0.2), 1.0 - (anxiety * 0.2)) # Redden slightly
	
	GameEvents.emit_signal("perception_distortion_updated", saturation, tint)
	
	if anxiety > 0.8:
		# Trigger random whispers via ProceduralHorror
		pass
