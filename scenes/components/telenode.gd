extends Area2D

@export var next_scene : PackedScene

func _on_body_entered(body: Node) -> void:
	SceneTransitionManager.to_next_scene(next_scene)
