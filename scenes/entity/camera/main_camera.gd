extends Camera2D

var centered := true
var dir := Vector2.ZERO
var follow_speed : float = 4
var max_dist : int = 16
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

func _move_camera(delta : float) -> void:
	var displacement := player.global_position - global_position
	if displacement.length() >= max_dist:
		global_position = global_position.lerp(player.global_position, delta * follow_speed)
		centered = false
