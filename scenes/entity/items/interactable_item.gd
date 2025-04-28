extends InteractableTile

@export var item_type : IngredientResource

func interaction_event() -> void:
	if item_type:
		InventoryManager.add_item(item_type.ref_name)
	
	queue_free()
