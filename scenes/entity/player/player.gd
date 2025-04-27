class_name Player extends CharacterBody2D

const SPEED : int = 8 * 16

@export var interaction_check_list : Array[RayCast2D]

var interaction_collision : InteractableTile

func _ready() -> void:
	add_to_group(&"player", true)

func _physics_process(delta: float) -> void:
	_check_interaction()

func _check_interaction() -> void:
	for check in interaction_check_list:
		if check.is_colliding():
			var body := check.get_collider()
			if body is InteractableTile:
				interaction_collision = body
				interaction_collision.colliding_check = check
	
	if interaction_collision:
		if interaction_check_list.has(interaction_collision.colliding_check):
			if not interaction_collision.colliding_check.is_colliding():
				interaction_collision.colliding_check = null
				interaction_collision = null
