extends InteractableTile

func _ready() -> void:
	$"AnimationPlayer".play(&"idle")

func interaction_event() -> void:
	GameGlobalEvents.open_craft_menu.emit()
