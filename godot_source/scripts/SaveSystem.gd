extends Node

## Hollow Signal - Save System
## Manages JSON serialization/deserialization of game state
## Add to Project Settings -> Autoload as 'SaveSystem'

const SAVE_PATH = "user://hollow_signal_save.json"

func save_game(player: CharacterBody2D):
	var data = {
		"player_pos_x": player.global_position.x,
		"player_pos_y": player.global_position.y,
		"inventory": player.get("inventory") if "inventory" in player else [],
		"current_level": get_tree().current_scene.scene_file_path,
		"achievements": AchievementManager.unlocked_achievements if has_node("/root/AchievementManager") else []
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(data)
		file.store_string(json_string)
		file.close()
		GameEvents.emit_signal("game_saved")
		print("Game Saved Successfully")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return null
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(content)
	if parse_result == OK:
		var data = json.get_data()
		GameEvents.emit_signal("game_loaded")
		return data
	
	return null
