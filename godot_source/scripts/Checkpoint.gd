extends Area2D

## Hollow Signal - Checkpoint
## Saves player location on contact

func _ready():
	# Ensure it detects player layer
	collision_layer = 0
	collision_mask = 2 # Assuming player is on layer 2

func _on_body_entered(body):
	if body.is_in_group("player"):
		GameEvents.emit_signal("checkpoint_reached", global_position)
		# Feedback: Play sound or visual effect
		_trigger_visual_feedback()

func _trigger_visual_feedback():
	# Example: Change light color or play animation
	pass
