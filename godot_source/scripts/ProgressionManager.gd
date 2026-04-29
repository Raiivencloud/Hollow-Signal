extends Node

## Hollow Signal - Progression Manager
## Controls the flow of levels and narrative beats
## Add to Project Settings -> Autoload as 'ProgressionManager'

var current_chapter: int = 1
var objectives_completed: Array[String] = []

func _ready():
	GameEvents.quest_completed.connect(_on_objective_met)

func _on_objective_met(quest_id: String):
	if not quest_id in objectives_completed:
		objectives_completed.append(quest_id)
		_check_chapter_progression()

func _check_chapter_progression():
	# Example condition: If all key items found, move forward
	if objectives_completed.size() >= 3:
		advance_chapter()

func advance_chapter():
	current_chapter += 1
	var next_level_path = "res://scenes/Level_0" + str(current_chapter) + ".tscn"
	SceneManager.transition_to(next_level_path)

func restart_from_checkpoint():
	# Implement reload logic using SceneManager and stored checkpoint data
	var last_cp = SceneManager.get_target_data("last_checkpoint")
	if last_cp:
		# Reload current scene and move player to checkpoint pos
		get_tree().reload_current_scene()
