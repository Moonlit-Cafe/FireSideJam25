extends InteractableTile

@export var job_menu : CanvasLayer

func interaction_event() -> void:
	print("Interacting")
	if not job_menu.visible:
		job_menu.show()
