extends CanvasLayer

@export var date : Label
@export var time : Label
@export var wait_screen : ColorRect

func _ready() -> void:
	wait_screen.color.a = 0
	
	GameGlobalEvents.time_changed.connect(_on_time_changed)
	GameGlobalEvents.map_generating.connect(_on_map_generating)
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

func _on_map_generating() -> void:
	var new_color := wait_screen.color
	new_color.a = 1
	wait_screen.color = new_color

func _on_map_generated() -> void:
	var new_color := wait_screen.color
	new_color.a = 0
	
	var tween := get_tree().create_tween().bind_node(wait_screen) as Tween
	tween.tween_property(wait_screen, "color", new_color, 1)
	GameGlobalEvents.resume_game.emit()
#endregion
