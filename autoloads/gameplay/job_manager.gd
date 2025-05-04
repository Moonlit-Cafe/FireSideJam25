extends Node

signal job_selected

# TODO: Need to show selected jobs somewhere

var selected_jobs : Array[TaskRequest]
var max_selectable_jobs : int = 3
var available_jobs : Array[TaskRequest]
var max_job_count : int = 5
var min_job_count : int = 3

func _ready() -> void:
	_on_week_changed()
	
	GameGlobalEvents.weekly_check.connect(_on_week_changed)

func select_job(job: TaskRequest) -> void:
	if selected_jobs.size() < max_selectable_jobs:
		available_jobs.erase(job)
		selected_jobs.append(job)
		job_selected.emit()

func complete_job(job: TaskRequest) -> void:
	if InventoryManager.get_item_count(job.request_needed) >= job.request_count:
		InventoryManager.money += job.request_value
		selected_jobs.erase(job)
	

func _on_week_changed() -> void:
	available_jobs.clear()
	
	for job_i in range(GameGlobal.rng.randi_range(min_job_count, max_job_count)):
		var job = TaskRequest.new()
		job.generate_request()
		available_jobs.append(job)
