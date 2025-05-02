extends CanvasLayer

var tele_node : TeleNode

func set_node(node: TeleNode) -> void:
	tele_node = node

func _on_cancel_button_pressed() -> void:
	GameGlobalEvents.resume_game.emit()
	tele_node.prompt = null
	queue_free()

func _on_continue_button_pressed() -> void:
	tele_node.teleport()
	_on_cancel_button_pressed()
