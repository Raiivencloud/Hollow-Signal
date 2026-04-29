extends Node2D

## Hollow Signal - Invisible Threat
## Detected only by sensory cues (audio/visual glitches)

@export var movement_speed: float = 50.0
@export var influence_radius: float = 300.0

var target: CharacterBody2D = null

func _ready():
	target = get_tree().get_first_node_in_group("player")

func _process(delta):
	if not target: return
	
	var dist = global_position.distance_to(target.global_position)
	
	if dist < influence_radius:
		# Slow chase
		var dir = global_position.direction_to(target.global_position)
		global_position += dir * movement_speed * delta
		
		# Notify sensory systems
		GameEvents.emit_signal("invisible_threat_proximity", dist)
		
		# Increase player anxiety via MentalSystem
		if has_node("/root/MentalSystem"):
			MentalSystem.add_anxiety(0.001)
