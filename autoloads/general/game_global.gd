extends Node

# TODO: Define all resources in detail bottle, recipe, ingredient

#region Children
var day_timer : Timer
#endregion

#region Global Variables
var time_of_day : int = 60 * 6
var days : int = 1
var rng := RandomNumberGenerator.new()
#endregion

#region Helper Variables
var time_tick : int = 2
var time_delta : int = 5
#endregion

#region Loading Up
func _ready() -> void:
	# Loading up sounds and then deleting the sound_loader as it's no longer necessary
	var sound_loader = SoundLoader.new()
	sound_loader.load_audio()
	sound_loader = null
	
	day_timer = Timer.new()
	add_child(day_timer)
	day_timer.timeout.connect(_on_day_timer_timeout)
	day_timer.start(time_tick)

#region Signal Callbacks
func _on_day_timer_timeout() -> void:
	if time_of_day >= (60 * 24) - time_delta:
		time_of_day -= (60 * 24)
		days += 1
		if days % 7 == 0:
			GameGlobalEvents.weekly_check.emit()
	
	time_of_day += time_delta
	
	if time_of_day % 30 == 0:
		GameGlobalEvents.check_item_respawn.emit()
	
	GameGlobalEvents.time_changed.emit()
	
	day_timer.start(time_tick)
#endregion

#region Helpers
func delay(time: float) -> void:
	await get_tree().create_timer(time).timeout
#endregion
