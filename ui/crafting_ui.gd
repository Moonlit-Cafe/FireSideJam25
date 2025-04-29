extends CanvasLayer

@export var ingredient_1 : OptionButton
@export var ingredient_2 : OptionButton
@export var content : Control
@export var animated_texture : AnimatedTextureRect

func _ready() -> void:
	add_to_group(&"ui")
	
	GameGlobalEvents.open_craft_menu.connect(open_craft_menu)
	
	if visible:
		_animate_content()

func open_craft_menu() -> void:
	animated_texture.current_animation = &"open"
	animated_texture.play()
	show()

func close_craft_menu() -> void:
	animated_texture.current_animation = &"close"
	animated_texture.play()
	content.hide()
	await animated_texture.animation_finished
	hide()
	content.show()

func _animate_content() -> void:
	content.hide()
	await animated_texture.animation_finished
	content.show()

func _on_visibility_changed() -> void:
	if visible:
		_animate_content()
		
		ingredient_1.clear()
		ingredient_2.clear()
		for item in InventoryManager.get_ingredients():
			ingredient_1.add_item(item)
			ingredient_2.add_item(item)

func _on_craft_button_pressed() -> void:
	CraftingManager.craft(ingredient_1.get_item_text(ingredient_1.get_selected_id()),
		ingredient_2.get_item_text(ingredient_2.get_selected_id()))
	
	_on_visibility_changed()
