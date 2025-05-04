class_name TeleNode extends Area2D

@export var tele_prompt : PackedScene
@export var next_scene : PackedScene

var prompt : CanvasLayer

func teleport() -> void:
	SceneTransitionManager.to_next_scene(next_scene)

func _on_body_entered(body: Node) -> void:
	if not prompt and tele_prompt:
		GameGlobalEvents.pause_game.emit()
		prompt = tele_prompt.instantiate()
		get_tree().root.add_child(prompt)
		prompt.set_node(self)

func _on_body_exited(body: Node) -> void:
	if prompt:
		prompt.queue_free()
		prompt = null
