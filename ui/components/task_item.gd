class_name TaskItem extends PanelContainer

@export var request_label : Label
@export var requester_label : Label

var task : TaskRequest

# TODO: Might want to make a popup for additional description?

func assign_task(task: TaskRequest) -> void:
	self.task = task
	request_label.text = "Need %s %s" % [task.request_count, task.request_needed]
	requester_label.text = task.requester

func _on_confirm_pressed() -> void:
	JobManager.select_job(task)
	queue_free()
