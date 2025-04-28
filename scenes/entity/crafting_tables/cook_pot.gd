extends InteractableTile

func interaction_event() -> void:
	GameGlobalEvents.open_craft_menu.emit()
