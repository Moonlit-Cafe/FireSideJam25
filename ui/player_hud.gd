extends CanvasLayer

@export var date : Label
@export var time : Label
@export var wait_screen : ColorRect

func _ready() -> void:
	GameGlobalEvents.time_changed.connect(_on_time_changed)
	GameGlobalEvents.map_generated.connect(_on_map_generated)

func _get_current_time() -> String:
	var current_time = GameGlobal.time_of_day
	var hour = current_time / 60
	var minute = current_time % 60
	var day_string = ""
	
	if hour < 10:
		day_string += "0%s" % hour
	else:
		day_string += str(hour)
	
	if minute < 10:
		day_string += ":0%s" % minute
	else:
		day_string += ":" + str(minute)
	
	return day_string
	

#region Signal Callbacks
func _on_time_changed() -> void:
	time.text = _get_current_time()
	date.text = str(GameGlobal.days)
#endregion

func _on_map_generated() -> void:
	var tween := get_tree().create_tween().bind_node(wait_screen) as Tween
	tween.tween_property(wait_screen, "color", Color(wait_screen.color.r, wait_screen.color.g, wait_screen.color.b, 0), 1)
	GameGlobalEvents.resume_game.emit()
