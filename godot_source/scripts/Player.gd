extends CharacterBody2D

## Hollow Signal - Player Script
## Handles 8-way movement and Flashlight logic

@export var speed: float = 200.0
@export var acceleration: float = 1200.0
@export var friction: float = 1000.0
@export var stealth_speed_mult: float = 0.5

@onready var flashlight = $Flashlight
@onready var anim_player = $AnimationPlayer
@onready var interact_ray = $InteractRayCast

var is_flashlight_on: bool = false
var is_crouching: bool = false
var nearest_interactable: Interactable = null

func _ready():
	flashlight.visible = is_flashlight_on
	anim_player.play("idle")

func _physics_process(delta):
	_handle_input_states()
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var current_speed = speed * (stealth_speed_mult if is_crouching else 1.0)
	_handle_movement(direction, delta, current_speed)
	_handle_animations(direction)
	_check_interactions()

func _handle_input_states():
	if Input.is_action_just_pressed("crouch"):
		is_crouching = !is_crouching
		GameEvents.emit_signal("stealth_state_changed", is_crouching)

func _handle_movement(direction, delta, move_speed):
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * move_speed, acceleration * delta)
		rotation = direction.angle()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

# Animation handling synchronized with state
func _handle_animations(direction):
	if direction != Vector2.ZERO:
		if Input.is_action_pressed("run"):
			anim_player.play("run")
		else:
			anim_player.play("walk")
			# Trigger footstep audio via animation track or script
			if not AudioManager.sfx_player.playing:
				AudioManager.play_footstep()
	else:
		anim_player.play("idle")

func _check_interactions():
	if interact_ray.is_colliding():
		var collider = interact_ray.get_collider()
		if collider is Interactable:
			if nearest_interactable != collider:
				nearest_interactable = collider
				GameEvents.emit_signal("interaction_prompt_toggled", true, collider.prompt_message)
	else:
		if nearest_interactable:
			nearest_interactable = null
			GameEvents.emit_signal("interaction_prompt_toggled", false, "")

func _input(event):
	if event.is_action_pressed("toggle_flashlight"):
		is_flashlight_on = !is_flashlight_on
		flashlight.visible = is_flashlight_on
		anim_player.play("flashlight_toggle")
		GameEvents.emit_signal("flashlight_toggled", is_flashlight_on)
	
	if event.is_action_pressed("interact") and nearest_interactable:
		nearest_interactable.interact()
