class_name Player extends CharacterBody2D

const SPEED : int = 4 * 16

@export var anim_tree : AnimationTree

var interaction_collision : InteractableTile
var interactable : Array[InteractableTile]
var anim_state_machine : AnimationNodeStateMachinePlayback

func _ready() -> void:
	if anim_tree:
		anim_state_machine = anim_tree.get("parameters/playback")
	
	add_to_group(&"player", true)
	InventoryManager.add_item(&"Florange")
	InventoryManager.add_item(&"Dawnapple")
	
	InventoryManager.get_inventory()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interactable.size() > 1:
		var shortest_dist : float = 1000.
		var closest_obj : InteractableTile
		for inter_obj in interactable:
			if global_position.distance_to(inter_obj.global_position) < shortest_dist:
				shortest_dist = global_position.distance_to(inter_obj.global_position)
				closest_obj = inter_obj
		closest_obj.interaction_event()
	elif event.is_action_pressed("interact") and interactable.size() > 0:
		interactable[0].interaction_event()
	elif event.is_action_pressed("close_menu"):
		var ui_nodes := get_tree().get_nodes_in_group(&"ui")
		var all_closed = true
		for ui in ui_nodes:
			if ui.visible:
				if ui.name == &"CraftingUI":
					ui.close_craft_menu()
				else:
					ui.hide()
				all_closed = false
				break
		
		if all_closed:
			GameGlobalEvents.pause_game.emit()

func _on_body_entered(body: Node2D) -> void:
	interactable.append(body)

func _on_body_exited(body: Node2D) -> void:
	for inter_obj in interactable:
		if inter_obj == body:
			if inter_obj.interact_type == Genum.InteractableType.CRAFTING:
				var ui_nodes = get_tree().get_nodes_in_group(&"ui")
				
				for ui in ui_nodes:
					if ui.name == &"CraftingUI" and ui.visible:
						ui.close_craft_menu()
			
			interactable.erase(inter_obj)
