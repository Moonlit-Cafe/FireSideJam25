class_name LevelGenerator extends Node2D

@export var main : TileMapLayer
@export var deco : TileMapLayer
@export var wfc_generator : WFC2DGenerator
@export var grass_collectables : Array[PackedScene]
@export var windgrass_collectables : Array[PackedScene]
@export var firegrass_collectables : Array[PackedScene]
@export var water_collectables : Array[PackedScene]
@export var collectable_holder : Node

# TODO: Find a better way of utilizing these, may just reduce to 2.
var lush := FastNoiseLite.new()
var humidity := FastNoiseLite.new()
var wind_speed := FastNoiseLite.new()

var check_area : Array[Vector2i]

func _ready() -> void:
	$sample.hide()
	$target.show()
	_generate_biomes()
	
	for x in range(5):
		for y in range(5):
			x -= 2
			y -= 2
			if Vector2i(x, y) != Vector2i.ZERO:
				check_area.append(Vector2i(x, y))

func find_safe_starting_pos() -> Vector2:
	var middle_point := wfc_generator.rect.size / 2
	var starting_point : Vector2i = middle_point
	var tile_data : TileData = main.get_cell_tile_data(starting_point)
	
	while tile_data.terrain != 0:
		starting_point += Vector2i(randi_range(-1, 1), randi_range(-1, 1))
		tile_data = main.get_cell_tile_data(starting_point)
	
	return to_global(main.map_to_local(starting_point))

func _generate_biomes() -> void:
	GameGlobalEvents.map_generating.emit()
	
	# TODO: Also include a radial or even quadrant region where biomes may spawn
	_define_noise(lush)
	_define_noise(humidity)
	_define_noise(wind_speed)
	var cell_count : int = 0
	
	# TODO: Need more rivers and less lakes, got to figure out how to remove the weird
	# single-tile patchy-ness I see.
	for x in range(wfc_generator.rect.size.x):
		for y in range(wfc_generator.rect.size.y):
			var lushness = lush.get_noise_2d(x, y) * 10
			var humid = humidity.get_noise_2d(x, y) * 10
			var windy = wind_speed.get_noise_2d(x, y) * 10
			
			_place_biome_tile(lushness, humid, windy, Vector2i(x, y))
	
	wfc_generator.start()
	await wfc_generator.done
	_add_collectables()

func _define_noise(noise: FastNoiseLite) -> void:
	noise.seed = randi()
	noise.frequency = 0.05
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH

func _add_collectables() -> void:
	# TODO: Change handling to include each different collectable item . . .
	# also need to make each new collectable item.
	for x in range(wfc_generator.rect.size.x):
		for y in range(wfc_generator.rect.size.y):
			var pos := Vector2i(x, y)
			if deco.get_cell_tile_data(pos):
				var biome := main.get_cell_tile_data(pos).terrain
				var idx : int = 0
				var collectable : InteractableItem
				if biome == 0 and grass_collectables.size() > 0:
					idx = GameGlobal.rng.randi_range(0, grass_collectables.size() - 1)
					collectable = grass_collectables.get(idx).instantiate()
				elif biome == 2 and water_collectables.size() > 0:
					idx = GameGlobal.rng.randi_range(0, water_collectables.size() - 1)
					collectable = water_collectables.get(idx).instantiate()
				elif biome == 3 and firegrass_collectables.size() > 0:
					idx = GameGlobal.rng.randi_range(0, firegrass_collectables.size() - 1)
					collectable = firegrass_collectables.get(idx).instantiate()
				elif biome == 4 and windgrass_collectables.size() > 0:
					idx = GameGlobal.rng.randi_range(0, windgrass_collectables.size() - 1)
					collectable = windgrass_collectables.get(idx).instantiate()
				
				collectable_holder.add_child(collectable)
				collectable.global_position = to_global(deco.map_to_local(Vector2i(x, y)))

func _place_biome_tile(l_noise: float, h_noise: float, w_noise: float, pos: Vector2i) -> void:
	# Grass Placement
	if l_noise > 3 and h_noise < 0 and _check_cell_allow(pos, 0):
		main.set_cell(pos, 0, Vector2i(1, 1))
	elif l_noise < -1 and h_noise > 3 and _check_cell_allow(pos, 2):
		main.set_cell(pos, 6, Vector2i(2, 1))
	elif l_noise < 2 and w_noise < -2 and h_noise < 0 and _check_cell_allow(pos, 3):
		main.set_cell(pos, 1, Vector2i(2, 1))
	elif w_noise > 5 and _check_cell_allow(pos, 4):
		main.set_cell(pos, 2, Vector2i(2, 1))

func _check_biome_allow(cell_value: float, value: float, delta: float) -> bool:
	return (value - delta < cell_value) and (cell_value < value + delta)

func _check_cell_allow(pos: Vector2i, terrain_id: int) -> bool:
	var can_place := true
	
	for area in check_area:
		var checked_tile = main.get_cell_tile_data(pos + area)
		if checked_tile:
			if terrain_id != checked_tile.terrain:
				can_place = false
	
	return can_place

func _on_wfc_finished() -> void:
	GameGlobalEvents.map_generated.emit()
	$progressIndicator.hide()
