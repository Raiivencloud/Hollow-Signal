extends Node

## Hollow Signal - Time Perception System
## Distorts reality by slowing or speeding up the engine scale

@export var distortion_duration: float = 3.0

func trigger_time_dilation(scale: float):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	# Transition engine timescale
	tween.tween_property(Engine, "time_scale", scale, 0.5)
	
	# Broadcast start
	GameEvents.emit_signal("time_distortion_active", scale)
	
	# Audio pitch shift if handled by AudioManager
	# AudioServer.set_bus_effect_enabled(...) 
	
	await get_tree().create_timer(distortion_duration).timeout
	
	# Return to normal
	var reset_tween = create_tween()
	reset_tween.tween_property(Engine, "time_scale", 1.0, 1.0)
