extends Node2D

@export var background_ost : StringName

func _ready() -> void:
	MusicManager.play_song(background_ost)
