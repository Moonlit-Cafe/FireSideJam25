extends PlayerState

var player : Player

func enter(previous_state : StringName, data : Dictionary = {}) -> void:
	player = owner as Player
	if data.has(&"dir"):
		player.anim_state_machine.travel(&"Idle")
		player.anim_tree.set(&"parameters/Idle/blend_position", data.get(&"dir"))

func physics_update(delta: float) -> void:
	var dir = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	
	if not dir.is_zero_approx():
		finished.emit(MOVING, {&"dir" : dir})
