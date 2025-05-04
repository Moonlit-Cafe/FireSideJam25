class_name InteractableItem extends InteractableTile

@export var item_type : IngredientResource
@export var sprites_to_hide : Array[AnimatedSprite2D]

var picked := false
var picked_time := Vector2i.ZERO

func _ready() -> void:
	GameGlobalEvents.check_item_respawn.connect(_on_item_check_respawn)
	
	for sprite in sprites_to_hide:
		sprite.play(&"default")

func interaction_event() -> void:
	if item_type and not picked:
		InventoryManager.add_to_inventory.emit()
		InventoryManager.add_item(item_type.ref_name)
		
	_got_picked()

func _got_picked() -> void:
	picked = true
	for sprite in sprites_to_hide:
		sprite.hide()

func _respawn_item() -> void:
	picked = false
	
	for sprite in sprites_to_hide:
		sprite.show()

func _on_item_check_respawn() -> void:
	if item_type.respawn_time and picked:
		if item_type.respawn_time.y <= GameGlobal.days - picked_time.y:
			if item_type.respawn_time.x <= GameGlobal.time_of_day - picked_time.x:
				_respawn_item()
