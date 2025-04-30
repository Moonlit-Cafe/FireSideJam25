extends InteractableTile

@export var item_type : IngredientResource
@export var sprite : Sprite2D

var picked := false
var picked_time := Vector2i.ZERO

func _ready() -> void:
	if item_type:
		if item_type.item_tile_sprite:
			sprite.texture = item_type.item_tile_sprite
	
	GameGlobalEvents.check_item_respawn.connect(_on_item_check_respawn)

func interaction_event() -> void:
	if item_type and not picked:
		InventoryManager.add_to_inventory.emit()
		InventoryManager.add_item(item_type.ref_name)
		
	_got_picked()

func _got_picked() -> void:
	picked = true
	picked_time = Vector2i(GameGlobal.time_of_day, GameGlobal.days)
	
	if item_type.item_tile_sprite_picked:
		sprite.texture = item_type.item_tile_sprite_picked
	else:
		hide()

func _respawn_item() -> void:
	picked = false
	
	if not visible:
		show()
	
	if item_type.item_tile_sprite:
		sprite.texture = item_type.item_tile_sprite

func _on_item_check_respawn() -> void:
	if item_type.respawn_time and picked:
		if item_type.respawn_time.y > GameGlobal.days - picked_time.y:
			if item_type.respawn_time.x > picked_time.x:
				_respawn_item()
