extends Node

## Hollow Signal - Dialogue System
## Handles branching conversations and UI display

var current_dialogue: Dictionary = {}
var current_step: int = 0

func start_dialogue(data: Dictionary):
	current_dialogue = data
	current_step = 0
	_display_current_step()

func _display_current_step():
	var line = current_dialogue.lines[current_step]
	var options = line.get("options", [])
	GameEvents.emit_signal("dialogue_line_displayed", line.text, options)

func select_option(index: int):
	var line = current_dialogue.lines[current_step]
	var options = line.get("options", [])
	
	if index < options.size():
		var next_id = options[index].next_id
		if next_id == "end":
			finish_dialogue()
		else:
			_goto_step(next_id)

func _goto_step(id: String):
	# Find index by ID
	for i in range(current_dialogue.lines.size()):
		if current_dialogue.lines[i].id == id:
			current_step = i
			_display_current_step()
			return

func finish_dialogue():
	GameEvents.emit_signal("dialogue_finished")
	current_dialogue = {}
