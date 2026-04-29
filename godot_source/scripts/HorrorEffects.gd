extends Node

## Hollow Signal - Horror & Anxiety Effects
## Manages camera shakes, screen distortions, and heartbeat sounds

@onready var camera = get_viewport().get_camera_2d()
var anxiety_level: float = 0.0 # 0.0 to 1.0

func _process(delta):
	# Apply subtle camera pulse based on anxiety
	if camera:
		var pulse = sin(Time.get_ticks_msec() * 0.005) * anxiety_level * 2.0
		camera.zoom = Vector2(1.0 + pulse * 0.01, 1.0 + pulse * 0.01)
		
		# Screen shake if high anxiety
		if anxiety_level > 0.7:
			camera.offset = Vector2(randf_range(-2, 2), randf_range(-2, 2)) * anxiety_level

func increase_anxiety(amount: float):
	anxiety_level = clamp(anxiety_level + amount, 0.0, 1.0)
	GameEvents.emit_signal("anxiety_level_changed", anxiety_level)
	
	# Trigger heartbeat sound if level is high
	if anxiety_level > 0.5:
		_play_heartbeat()

func _play_heartbeat():
	# Slower or faster based on level
	pass
