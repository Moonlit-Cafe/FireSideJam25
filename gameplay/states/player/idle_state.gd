extends PlayerState

func enter(previous_state : StringName, data : Dictionary = {}) -> void:
	print("Entered Idle State")

func physics_update(delta: float) -> void:
	var dir = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	
	if not dir.is_zero_approx():
		finished.emit(MOVING, {&"dir" : dir})
