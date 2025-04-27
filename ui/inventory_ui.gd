extends CanvasLayer

@export var item_list : VBoxContainer
@export var close_button : Button

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"open_inventory"):
		if visible:
			hide()
		else:
			show()
			_update_inventory_list()

func _update_inventory_list() -> void:
	var inv := InventoryManager.get_inventory()
	
	for child in item_list.get_children():
		item_list.remove_child(child)
		child.queue_free()
	
	for item in inv.keys():
		_create_inventory_label(item, inv.get(item))

func _create_inventory_label(item_name : StringName, item_count : int) -> void:
	var hbox_cont := HBoxContainer.new()
	var item_label := Label.new()
	var item_count_label := Label.new()
	
	item_list.add_child(hbox_cont)
	hbox_cont.add_child(item_label)
	hbox_cont.add_child(item_count_label)
	
	item_label.size_flags_horizontal = Control.SIZE_FILL
	item_label.text = item_name
	item_count_label.text = str(item_count)
