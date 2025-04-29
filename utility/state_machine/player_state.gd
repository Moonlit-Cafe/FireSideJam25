class_name PlayerState extends State

const IDLE := &"Idle"
const MOVING := &"Moving"
const PAUSED := &"Pause"

func _ready() -> void:
	GameGlobalEvents.pause_game.connect(_on_game_paused)

func _on_game_paused() -> void:
	finished.emit(PAUSED)
