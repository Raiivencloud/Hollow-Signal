extends Node

## Hollow Signal - Achievement Manager
## Tracks game milestones and persists them
## Add to Project Settings -> Autoload as 'AchievementManager'

var unlocked_achievements: Array[String] = []

var achievements_db = {
	"first_light": {"title": "Let There Be Light", "desc": "Turn on your flashlight for the first time."},
	"stalked": {"title": "Being Watched", "desc": "Detected by the stalker."},
	"survivor": {"title": "Survivor", "desc": "Complete the first level without being caught."}
}

func _ready():
	GameEvents.flashlight_toggled.connect(func(on): if on: unlock_achievement("first_light"))
	GameEvents.player_detected.connect(func(): unlock_achievement("stalked"))

func unlock_achievement(id: String):
	if id in unlocked_achievements: return
	
	if id in achievements_db:
		unlocked_achievements.append(id)
		var data = achievements_db[id]
		GameEvents.emit_signal("achievement_unlocked", id, data.title)
		print("Achievement Unlocked: ", data.title)
		# Optional: Auto-save on achievement
		# SaveSystem.save_game(...)
