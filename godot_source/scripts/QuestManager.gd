extends Node

## Hollow Signal - Quest Manager
## Tracks active objectives and progress

var active_quests: Dictionary = {}

func start_quest(id: String, title: String):
	if id in active_quests: return
	active_quests[id] = {"title": title, "progress": 0.0, "status": "ACTIVE"}
	GameEvents.emit_signal("quest_started", id)

func update_progress(id: String, progress: float):
	if id in active_quests:
		active_quests[id].progress = clamp(progress, 0.0, 1.0)
		GameEvents.emit_signal("quest_updated", id, progress)
		if progress >= 1.0:
			complete_quest(id)

func complete_quest(id: String):
	if id in active_quests:
		active_quests[id].status = "COMPLETED"
		GameEvents.emit_signal("quest_completed", id)
