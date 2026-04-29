extends Node

## Hollow Signal - Scene Manager
## Handles transitions between scenes and persists player state
## Add this to Project Settings -> Autoload as 'SceneManager'

var persistent_data: Dictionary = {} # Stores health, items, etc.
var is_loading: bool = false

# Transition to a new scene with an optional fade
func transition_to(scene_path: String, data_to_pass: Dictionary = {}):
	if is_loading: return
	is_loading = true
	
	# Pass data into persistence layer
	for key in data_to_pass.keys():
		persistent_data[key] = data_to_pass[key]
	
	# Implementation Note: 
	# In a full project, you would trigger an AnimationPlayer here 
	# that fades a black ColorRect to alpha 1.0.
	
	# Simulated visual transition delay
	await get_tree().create_timer(1.2).timeout
	
	# Load the actual scene
	var error = get_tree().change_scene_to_file(scene_path)
	
	if error != OK:
		push_error("SCENE_LOAD_ERROR: Could not find " + scene_path)
		# Path verification: ensure scenes are listed in project.godot
	
	is_loading = false

# Retrieves stored data after transition
func get_target_data(key: String, default = null):
	return persistent_data.get(key, default)
