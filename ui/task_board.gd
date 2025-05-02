extends CanvasLayer

@export var menu : Control
@export var task_list : VBoxContainer
@export var task_item_scene : PackedScene

func _ready() -> void:
	JobManager.job_selected.connect(_on_job_selected)

func fill_task_menu() -> void:
	for task in JobManager.available_jobs:
		var task_item = task_item_scene.instantiate() as TaskItem
		task_list.add_child(task_item)
		task_item.assign_task(task)

func _on_visibility_changed() -> void:
	if visible:
		GameGlobalEvents.pause_game.emit()
		menu.mouse_filter = Control.MOUSE_FILTER_STOP
		fill_task_menu()

func _close_button_pushed() -> void:
	GameGlobalEvents.resume_game.emit()
	menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hide()

func _on_job_selected() -> void:
	fill_task_menu()
