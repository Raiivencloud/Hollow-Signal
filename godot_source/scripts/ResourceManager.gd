extends Node

## Hollow Signal - Resource Management
## Tracks finite items like batteries and ammo
## Add to Project Settings -> Autoload as 'ResourceManager'

var flashlight_battery: float = 100.0
var ammo_count: int = 0

func _process(delta):
	# Drain battery when flashlight is on
	var player = get_tree().get_first_node_in_group("player")
	if player and player.is_flashlight_on:
		consume_battery(2.0 * delta)

func consume_battery(amount: float):
	flashlight_battery = max(0, flashlight_battery - amount)
	
	if flashlight_battery < 20.0:
		GameEvents.emit_signal("resource_critical", "battery")
		# Force flicker via LightingController
	
	if flashlight_battery <= 0:
		# Auto-disable flashlight
		var player = get_tree().get_first_node_in_group("player")
		if player: player.is_flashlight_on = false

func add_ammo(amount: int):
	ammo_count += amount
	print("Ammo: ", ammo_count)
