extends PlayerState

var dir := Vector2.ZERO

func enter(previous_state : StringName, data := {}) -> void:
	print("Entered Moving State")

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
	pass
