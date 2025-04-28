extends CanvasLayer

@export var generator: WFC2DGenerator

func _ready():
	%ProgressBar.min_value = 0
	%ProgressBar.max_value = 1.0
	%ProgressBar.step = 0.001

	generator.started.connect(on_start)
	generator.done.connect(on_done)

func _process(delta):
	%ProgressBar.value = generator.get_progress()

var start_time: int = 0

func on_start():
	%StatusLabel.text = "Started"
	start_time = Time.get_ticks_msec()

func on_done():
	var delta = Time.get_ticks_msec() - start_time

	%StatusLabel.text = "Done in %.2f second(s)" % (0.001 * delta)
