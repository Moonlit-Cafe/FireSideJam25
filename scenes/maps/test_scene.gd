extends Node2D

@export var map_gen : LevelGenerator
@export var player : Player

var starting_pos : Vector2

func _ready() -> void:
	GameGlobalEvents.pause_game.emit()
	
	if map_gen and player:
		await map_gen.generated_map
		player.global_position = map_gen.find_safe_starting_pos()
		GameGlobalEvents.map_generated.emit()
