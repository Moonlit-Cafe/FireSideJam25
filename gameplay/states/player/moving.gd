extends PlayerState

@export var walk_timer : Timer

var dir := Vector2.ZERO
var p_dir := Vector2.ZERO
var player : Player
var can_walk_sound := true
var walk_delta : float = 0.5
var walk_sound_array : Array[StringName] = [
	&"step1", &"step2", &"step3", &"step4",
	&"step5", &"step6", &"step7", &"step8",
	&"step9", &"step10", &"step11",
]

func _ready() -> void:
	walk_timer.timeout.connect(_on_walk_timeout)
	walk_timer.start(walk_delta)
	can_walk_sound = true

func enter(previous_state : StringName, data := {}) -> void:
	player = owner
	player.anim_state_machine.travel("Moving")

func physics_update(delta : float) -> void:
	get_input()
	if dir.is_zero_approx():
		finished.emit(IDLE, {&"dir": p_dir})
	
	animate()
	move()

func get_input() -> void:
	p_dir = dir
	
	dir = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	dir.normalized()

func animate() -> void:
	player.anim_tree.set(&"parameters/Moving/blend_position", dir)

func move() -> void:
	player.velocity = dir * player.SPEED
	player.move_and_slide()
	
	if can_walk_sound:
		print("Playing sound")
		SoundManager.play_sound(walk_sound_array.get(randi_range(0, walk_sound_array.size() - 1)))
		walk_timer.start(walk_delta)
		can_walk_sound = false

func _on_walk_timeout() -> void:
	can_walk_sound = true
