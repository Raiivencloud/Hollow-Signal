extends CharacterBody2D

## Hollow Signal - Stalker AI (Advanced)
## Features: Patrolling, stillness detection, radio static emissions

@export var patrol_points: Array[Vector2] = []
@export var stalking_speed: float = 80.0
@export var chase_speed: float = 220.0
@export var detection_radius: float = 400.0
@export var stillness_multiplier: float = 2.5 # How much faster it moves if player stops

var current_patrol_index: int = 0
var target: CharacterBody2D = null
var behavior_state: String = "PATROL" # PATROL, STALKING, CHASING
var is_player_light_on: bool = false
var static_level: float = 0.0

func _ready():
	# Identify the player node
	target = get_tree().get_first_node_in_group("player")
	# Subscribe to flashlight signals
	GameEvents.flashlight_toggled.connect(_on_player_flashlight_toggled)

func _physics_process(delta):
	if not target: return
	
	var distance_to_player = global_position.distance_to(target.global_position)
	_update_radio_signals(distance_to_player)
	
	match behavior_state:
		"PATROL":
			_patrol_logic()
			# Detection threshold: Light must be on and player within range
			if is_player_light_on and distance_to_player < detection_radius:
				behavior_state = "STALKING"
				GameEvents.emit_signal("player_detected")
		
		"STALKING":
			_stalk_logic()
			if distance_to_player < 150.0:
				behavior_state = "CHASING"
			elif not is_player_light_on:
				behavior_state = "PATROL"
				
		"CHASING":
			_chase_logic()
			if not is_player_light_on and distance_to_player > 500.0:
				behavior_state = "PATROL"

# Patrolling logic: Moving between waypoints
func _patrol_logic():
	if patrol_points.is_empty(): return
	var target_pt = patrol_points[current_patrol_index]
	
	if global_position.distance_to(target_pt) < 15.0:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
	
	var dir = global_position.direction_to(target_pt)
	velocity = dir * (stalking_speed * 0.5)
	move_and_slide()

# Stalking logic: Creeps toward player, faster if player is immobile
func _stalk_logic():
	var dir = global_position.direction_to(target.global_position)
	
	# Detect if player is still (velocity near zero)
	var player_is_still = target.velocity.length() < 10.0
	var current_move_speed = stalking_speed * (stillness_multiplier if player_is_still else 1.0)
	
	velocity = dir * current_move_speed
	move_and_slide()

# Chase logic: High speed direct approach
func _chase_logic():
	var dir = global_position.direction_to(target.global_position)
	velocity = dir * chase_speed
	move_and_slide()

# Updates radio static via global events based on proximity
func _update_radio_signals(dist: float):
	static_level = clamp(1.0 - (dist / 500.0), 0.0, 1.0)
	GameEvents.emit_signal("radio_static_intensity", static_level)

func _on_player_flashlight_toggled(light_on: bool):
	is_player_light_on = light_on
	if not light_on and behavior_state == "CHASING":
		# Optional: Keep chasing for a few seconds even if light is off
		pass
