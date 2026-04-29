extends Camera2D

## Hollow Signal - Dynamic Horror Camera
## Adapts to player motion, anxiety, and guides the gaze

@export var base_zoom: Vector2 = Vector2(1.2, 1.2)
@export var anxiety_zoom_mult: float = 0.15
@export var smoothing_speed: float = 5.0

var target: Node2D = null
var current_shake: float = 0.0

func _ready():
	target = get_tree().get_first_node_in_group("player")
	GameEvents.anxiety_level_changed.connect(_on_anxiety_changed)

func _process(delta):
	if not target: return
	
	# Basic following with lead
	var move_vel = target.get("velocity") if "velocity" in target else Vector2.ZERO
	var offset_target = move_vel * 0.2 # Look ahead
	
	# Guide towards darkness (look for areas with low light density)
	# Simplified: Drift slightly away from the player's center toward the direction of rotation
	var guide_drift = Vector2.RIGHT.rotated(target.rotation) * 40.0
	
	global_position = global_position.lerp(target.global_position + offset_target + guide_drift, smoothing_speed * delta)
	
	# Apply Shake
	if current_shake > 0:
		offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * current_shake
		current_shake = move_toward(current_shake, 0, delta * 10.0)

func _on_anxiety_changed(lvl: float):
	# Close in as anxiety rises
	zoom = base_zoom + Vector2(lvl * anxiety_zoom_mult, lvl * anxiety_zoom_mult)
	
	# Add subtle continuous jitter at high anxiety
	if lvl > 0.6:
		current_shake = lvl * 3.0
