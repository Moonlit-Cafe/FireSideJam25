extends PlayerState

func _ready() -> void:
	GameGlobalEvents.resume_game.connect(_on_game_resumed)

func _on_game_resumed() -> void:
	finished.emit(IDLE)
