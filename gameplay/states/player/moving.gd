extends PlayerState

var dir := Vector2.ZERO
var p_dir := Vector2.ZERO
var player : Player

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
