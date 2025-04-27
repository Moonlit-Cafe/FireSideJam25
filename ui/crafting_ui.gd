extends CanvasLayer

@export var ingredient_1 : OptionButton
@export var ingredient_2 : OptionButton

func _on_visibility_changed() -> void:
	if visible:
		ingredient_1.clear()
		ingredient_2.clear()
		for item in InventoryManager.get_ingredients():
			ingredient_1.add_item(item)
			ingredient_2.add_item(item)

func _on_craft_button_pressed() -> void:
	CraftingManager.craft(ingredient_1.get_item_text(ingredient_1.get_selected_id()),
		ingredient_2.get_item_text(ingredient_2.get_selected_id()))
	
	_on_visibility_changed()
