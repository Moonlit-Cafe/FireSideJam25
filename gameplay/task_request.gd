class_name TaskRequest

const REQUESTERS : Array[StringName] = [
	"Billy",
	"Veole",
	"Mina"
]

var request_needed : StringName
var request_count : int
var request_description : String
var request_value : int

func generate_request() -> void:
	if GameGlobal.rng.randi_range(0, 1) == 0:
		generate_ingredient_request()
	else:
		generate_bottle_request()

func generate_ingredient_request() -> void:
	var ingredients : Array[StringName] = CraftingManager.ingredients.keys()
	request_needed = ingredients[GameGlobal.rng.randi_range(0, ingredients.size() - 1)]
	request_count = GameGlobal.rng.randi_range(0, 10)
	request_value = CraftingManager.ingredients.get(request_needed).item_value * request_count
	
	request_description = "This is the guild informing you that " + REQUESTERS[GameGlobal.rng.randi_range(0, REQUESTERS.size() - 1)] + " has requested that you retrieve %s %s. Upon completing the request you'll receive %sgs" % [request_count, request_needed, request_value]

func generate_bottle_request() -> void:
	var bottles : Array[StringName] = CraftingManager.bottles.keys()
	request_needed = bottles[GameGlobal.rng.randi_range(0, bottles.size() - 1)]
	request_count = GameGlobal.rng.randi_range(0, 10)
	request_value = CraftingManager.ingredients.get(request_needed).bottle_value * request_count
	
	request_description = "This is the guild informing you that " + REQUESTERS[GameGlobal.rng.randi_range(0, REQUESTERS.size() - 1)] + " has requested that you make %s %s potions. Upon completing the request you'll receive %sgs" % [request_count, request_needed, request_value]
