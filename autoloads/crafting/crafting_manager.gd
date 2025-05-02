extends Node

var bottles : Dictionary[StringName, BottleResource] = {}
var ingredients : Dictionary[StringName, IngredientResource] = {}
var recipes : Dictionary[StringName, RecipeResource] = {}
var general_path := "res://gameplay/crafting/"

func _ready() -> void:
	_load_resources(general_path + "bottles/", "BottleResource", bottles)
	_load_resources(general_path + "ingredient/", "IngredientResource", ingredients)
	_load_resources(general_path + "recipes/", "RecipeResource", recipes)

func craft(ing_1: StringName, ing_2: StringName) -> void:
	var item_1 := InventoryManager.get_item(ing_1) as IngredientResource
	var item_2 := InventoryManager.get_item(ing_2) as IngredientResource
	
	var found_recipe := false
	
	if item_1 and item_2:
		for recipe in recipes.values():
			recipe = recipe as RecipeResource
			if item_1 == recipe.item_ingredient_1 and item_2 == recipe.item_ingredient_2:
				found_recipe = true
				InventoryManager.remove_item(ing_1)
				InventoryManager.remove_item(ing_2)
				InventoryManager.add_item(recipe.item_result_bottle.ref_name)
	else:
		push_warning("The player does not have these items.")
	
	if not found_recipe:
		push_warning("There is no such recipe with %s and %s as ingredients" % [ing_1, ing_2])

func _load_resources(path: String, type: String, storage: Dictionary) -> void:
	pass
	var loaded_path := ResourceLoader.list_directory(path)
	for item in loaded_path:
		var loaded_item = ResourceLoader.load(path + item, type)
		if loaded_item is RecipeResource:
			storage.set(loaded_item.item_result_bottle.ref_name, loaded_item)
		else:
			storage.set(loaded_item.ref_name, loaded_item)
