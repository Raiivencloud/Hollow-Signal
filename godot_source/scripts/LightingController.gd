extends Node2D

## Hollow Signal - Lighting Controller
## Manages flashlight instability and environmental flickering

@export var flicker_chance: float = 0.02
@export var min_energy: float = 0.2
@export var max_energy: float = 1.2

@onready var light: PointLight2D = $Flashlight # Assumes node structure

var is_flickering: bool = false
var base_energy: float = 1.0

func _ready():
	if light: base_energy = light.energy
	GameEvents.anxiety_level_changed.connect(_on_anxiety_changed)

func _process(_delta):
	if not light or not light.visible: return
	
	# Random flicker logic
	if is_flickering or randf() < flicker_chance:
		_flicker_effect()

func _flicker_effect():
	light.energy = randf_range(min_energy, max_energy)
	# Return to base energy after a random short burst
	await get_tree().create_timer(randf_range(0.05, 0.15)).timeout
	light.energy = base_energy

func _on_anxiety_changed(lvl: float):
	# As anxiety rises, light becomes more unstable
	flicker_chance = 0.01 + (lvl * 0.1)
	light.color = Color(1.0, 1.0, 1.0 - (lvl * 0.3)) # Drain blue, turn light yellowish/warm
