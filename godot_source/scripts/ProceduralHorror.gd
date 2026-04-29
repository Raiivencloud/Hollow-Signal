extends Node

## Hollow Signal - Procedural Horror Events
## Triggers unpredictable sounds, shadow sightings, and environment shifts

@export var tick_rate: float = 5.0 # Check for events every X seconds

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = tick_rate
	timer.timeout.connect(_on_tick)
	timer.start()

func _on_tick():
	# Chance based on global paranoia level
	var p_level = MentalSystem.paranoia if has_node("/root/MentalSystem") else 0.5
	
	if randf() < 0.2 * p_level:
		_trigger_random_event()

func _trigger_random_event():
	var events = ["SOUND_THUD", "LIGHT_OFF", "SHADOW_FUGITIVE", "WHISPER"]
	var choice = events[randi() % events.size()]
	
	match choice:
		"SOUND_THUD":
			AudioManager.play_ui_sound("thud_distal")
		"LIGHT_OFF":
			_cause_temporary_darkness()
		"SHADOW_FUGITIVE":
			_spawn_visual_glitch()
	
	GameEvents.emit_signal("environment_event_triggered", choice)

func _cause_temporary_darkness():
	# Briefly disable nearby lights or flicker whole scene
	pass

func _spawn_visual_glitch():
	# Spawn a ghost sprite that disappears when approached
	pass
