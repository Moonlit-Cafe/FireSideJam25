extends Node

@export var game_node : Node2D
@export var starting_scene : PackedScene

func _ready() -> void:
	if game_node:
		SceneTransitionManager.game_scene = game_node
	else:
		SceneTransitionManager.game_scene = self
	
	if starting_scene:
		print("Changing Scenes")
		SceneTransitionManager.to_next_scene(starting_scene)
