extends Node

var inventory : Dictionary[StringName, int]

func get_inventory() -> Dictionary[StringName, int]:
	return inventory

func add_item(item : StringName) -> void:
	if get_item_count(item) == 0:
		inventory.set(item, 1)
	else:
		inventory.set(item, get_item_count(item) + 1)

func add_item_amount(item : StringName, value: int) -> void:
	for v in range(value):
		add_item(item)

func get_item(item : StringName) -> Variant:
	if item in inventory:
		if item in CraftingManager.bottles:
			return CraftingManager.bottles.get(item)
		elif item in CraftingManager.ingredients:
			return CraftingManager.ingredients.get(item)
		else:
			push_error("There is no item " + item + " in the crafting system")
	else:
		push_error("There is no item " + item + " in the inventory")
	
	return null

func get_item_count(item : StringName) -> int:
	return inventory.get(item, 0)

func remove_item(item: StringName) -> void:
	if item in inventory:
		if get_item_count(item) > 1:
			inventory.set(item, get_item_count(item) - 1)
		else:
			inventory.erase(item)

func remove_item_amount(item: StringName, value: int) -> void:
	for v in range(value):
		if get_item_count(item) > 0:
			remove_item(item)

func get_ingredients() -> Array[StringName]:
	var ingredient_array : Array[StringName] = []
	
	for item in inventory.keys():
		if item in CraftingManager.ingredients:
			ingredient_array.append(item)
	
	return ingredient_array
