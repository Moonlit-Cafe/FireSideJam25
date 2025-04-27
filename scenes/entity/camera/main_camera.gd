extends Camera2D

var dir := Vector2.ZERO
var dist_time : float = 1.5
var max_dist : int = 150
var player : CharacterBody2D

var ranged_speed : int

func _ready() -> void:
	_find_player()

func _physics_process(delta: float) -> void:
	if not player:
		_find_player()
	
	if player:
		_move_camera(delta)

func _find_player() -> void:
	if get_tree().get_node_count_in_group(&"player") > 0:
		player = get_tree().get_first_node_in_group(&"player")
		
		ranged_speed = (max_dist / dist_time) + player.SPEED

func _move_camera(delta : float) -> void:
	var displacement := player.global_position - global_position
	if not displacement.is_zero_approx():
		#print("Displacement is %s" % displacement)
		if displacement.length() >= max_dist:
			global_position += displacement.normalized() * ranged_speed * delta
		elif displacement.length() <= 1:
			global_position = player.global_position
		else:
			global_position += (displacement / max_dist) * ranged_speed * delta
