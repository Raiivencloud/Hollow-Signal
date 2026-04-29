extends Area2D
class_name Interactable

## Hollow Signal - Interaction Base
## Place this on objects the player can interact with

@export var prompt_message: String = "Interact"
@export var is_one_shot: bool = false

signal interacted()

func _ready():
	# Ensure collision layers match player detection
	collision_layer = 4 # Interaction layer
	collision_mask = 0

func interact():
	emit_signal("interacted")
	if is_one_shot:
		queue_free()
