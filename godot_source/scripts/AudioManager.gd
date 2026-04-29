extends Node

## Hollow Signal - Audio Manager
## Manages dynamic ambient sounds and player foley
## Add to Project Settings -> Autoload as 'AudioManager'

@onready var ambient_player = AudioStreamPlayer.new()
@onready var static_player = AudioStreamPlayer.new()
@onready var sfx_player = AudioStreamPlayer.new()

func _ready():
	add_child(ambient_player)
	add_child(static_player)
	add_child(sfx_player)
	
	# Setup bus and looping
	ambient_player.bus = "Ambient"
	static_player.bus = "Static"
	
	# Connect to radio signals
	GameEvents.radio_static_intensity.connect(_on_static_changed)

func play_footstep():
	# Randomized pitch for natural feel
	sfx_player.pitch_scale = randf_range(0.9, 1.1)
	# sfx_player.stream = load("res://assets/audio/step.wav")
	sfx_player.play()

func _on_static_changed(intensity: float):
	# Map intensity to volume/cutoff filters
	var db_volume = linear_to_db(intensity)
	static_player.volume_db = db_volume
	
	# Emit visual distortion level based on static
	GameEvents.emit_signal("presence_intensity_changed", intensity)

func play_ui_sound(sound_type: String):
	pass # Logic for menu/interaction sounds
