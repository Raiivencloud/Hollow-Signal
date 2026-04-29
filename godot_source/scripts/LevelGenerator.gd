extends Node

## Hollow Signal - Level Generator / Dificulty Manager
## Handles dynamic scaling of enemies and procedural spawn points

@export var base_enemy_count: int = 1
@export var difficulty_curve: float = 1.2 # Multiplier per level

func generate_level(level_index: int):
	var enemy_count = floor(base_enemy_count * pow(difficulty_curve, level_index))
	print("Generating Level ", level_index, " with ", enemy_count, " stalkers")
	
	# Logic for instantiating tilesets or room scenes
	# for i in range(enemy_count):
	#    spawn_stalker()
	
	# Pass difficulty data to the environment
	_apply_mood_settings(level_index)

func _apply_mood_settings(level_index):
	# Increase fog or decrease global light intensity as level increases
	var ambient_darkness = clamp(0.1 + (level_index * 0.05), 0.1, 0.8)
	# Set WorldEnvironment intensity...
