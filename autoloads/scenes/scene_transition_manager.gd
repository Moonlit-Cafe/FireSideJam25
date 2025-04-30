extends Node

var next_scene : StringName
var game_scene : Node

func to_next_scene(scene) -> void:
	if game_scene:
		for child in game_scene.get_children():
			child.queue_free()
		
		if scene is PackedScene:
			var new_scene = scene.instantiate()
			game_scene.add_child(new_scene)
		elif scene is StringName:
			if ResourceLoader.exists(scene):
				var new_instantiable_scene := ResourceLoader.load(scene)
				var new_scene = new_instantiable_scene.instatiate()
				game_scene.add_child(new_scene)
