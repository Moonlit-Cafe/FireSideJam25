class_name InteractableItem extends InteractableTile

@export var item_type : IngredientResource

var picked := false
var picked_time := Vector2i.ZERO

# TODO: Change code handling so that we reference what's been picked and what hasn't
# and that it's those that are hidden and shown. Probably an Array of AnimatedSprites?

func _ready() -> void:
	GameGlobalEvents.check_item_respawn.connect(_on_item_check_respawn)

func interaction_event() -> void:
	if item_type and not picked:
		InventoryManager.add_to_inventory.emit()
		InventoryManager.add_item(item_type.ref_name)
		
	_got_picked()

func _got_picked() -> void:
	picked = true
	hide()

func _respawn_item() -> void:
	picked = false
	
	if not visible:
		show()

func _on_item_check_respawn() -> void:
	if item_type.respawn_time and picked:
		if item_type.respawn_time.y > GameGlobal.days - picked_time.y:
			if item_type.respawn_time.x > picked_time.x:
				_respawn_item()
