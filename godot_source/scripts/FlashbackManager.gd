extends CanvasLayer

## Hollow Signal - Flashback Manager
## Overlays past scenes or visual glitches

@onready var color_rect = $ColorRect # Fullscreen overlay

func _ready():
	GameEvents.flashback_triggered.connect(_on_flashback)

func _on_flashback(scene_id: String):
	# Implementation: Desaturate view and play echoey audio
	var tween = create_tween()
	
	# Fade in flashback effect
	tween.tween_property(color_rect, "modulate:a", 0.5, 0.5)
	
	# Display specific flashback image or play scene clip
	print("Starting Flashback: ", scene_id)
	
	await get_tree().create_timer(2.0).timeout
	
	# Fade out
	var fade_out = create_tween()
	fade_out.tween_property(color_rect, "modulate:a", 0.0, 1.0)
