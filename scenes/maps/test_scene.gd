extends Node2D

@export var map_gen : LevelGenerator
@export var player : Player

func _ready() -> void:
	GameGlobalEvents.pause_game.emit()
	
	if map_gen and player:
		await GameGlobalEvents.map_generated
		player.global_position = map_gen.find_safe_starting_pos()
