extends PlayerState

const SPEED : int = 2 * 64

var dir := Vector2.ZERO
var player : CharacterBody2D

func enter(previous_state : StringName, data := {}) -> void:
	print("Entered Moving State")
	player = owner

func physics_update(delta : float) -> void:
	get_input()
	animate()
	move()
	
	if dir.is_zero_approx():
		finished.emit(IDLE, {})

func get_input() -> void:
	dir = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	dir.normalized()

func animate() -> void:
	pass

func move() -> void:
	player.velocity = dir * SPEED
	player.move_and_slide()
