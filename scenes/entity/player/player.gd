class_name Player extends CharacterBody2D

const SPEED : int = 8 * 16

@export var interaction_check_list : Array[RayCast2D]
@export var anim_tree : AnimationTree

@export var ui_holder : Array[CanvasLayer]

var interaction_collision : InteractableTile
var anim_state_machine : AnimationNodeStateMachinePlayback

func _ready() -> void:
	if anim_tree:
		anim_state_machine = anim_tree.get("parameters/playback")
	
	add_to_group(&"player", true)
	InventoryManager.add_item(&"Florange")
	InventoryManager.add_item(&"Dawnapple")
	
	InventoryManager.get_inventory()

func _physics_process(delta: float) -> void:
	_check_interaction()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interaction_collision:
		interaction_collision.interaction_event()
	elif event.is_action_pressed("close_menu"):
		var ui_nodes := get_tree().get_nodes_in_group(&"ui")
		var all_closed = true
		for ui in ui_nodes:
			if ui.visible:
				ui.hide()
				all_closed = false
				break
		
		if all_closed:
			GameGlobalEvents.pause_game.emit()

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
