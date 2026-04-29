extends Node

## Hollow Signal - Inventory Manager
## Manages items and UI state

var items: Array = [] # Array of Dictionary {id, name, qty, desc}

func add_item(item_id: String, qty: int = 1):
	# Check if exists
	for item in items:
		if item.id == item_id:
			item.qty += qty
			GameEvents.emit_signal("item_collected", item_id)
			return
	
	# Add new (Mock lookup)
	var new_item = {"id": item_id, "name": "Item Name", "qty": qty, "desc": "Description"}
	items.append(new_item)
	GameEvents.emit_signal("item_collected", item_id)

func use_item(item_id: String):
	for i in range(items.size()):
		if items[i].id == item_id:
			items[i].qty -= 1
			if items[i].qty <= 0:
				items.remove_at(i)
			GameEvents.emit_signal("item_used", item_id)
			return
