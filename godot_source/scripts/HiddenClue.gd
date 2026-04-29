extends Interactable
class_name HiddenClue

## Hollow Signal - Hidden Clue
## Only reveals when light is focused or specific condition is met

@export var required_light_intensity: float = 0.8
@export var clue_text: String = "Something is written here..."

var is_revealed: bool = false

func _process(_delta):
	if is_revealed: return
	
	var player = get_tree().get_first_node_in_group("player")
	if player and player.is_flashlight_on:
		var dist = global_position.distance_to(player.global_position)
		if dist < 100.0:
			# Potentially check flashlight angle/dot product here
			reveal_clue()

func reveal_clue():
	is_revealed = true
	# Visual effect: Fade in decal or sprite
	GameEvents.emit_signal("clue_found", clue_text)
	print("Clue Found: ", clue_text)
