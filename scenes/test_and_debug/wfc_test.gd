#extends TileMapLayer
#
#@export var grid_size: Vector2i = Vector2i(10, 10)
#var grid = []
#var possible_tiles = []
#var tile_terrain: Dictionary = {}
#var tile_ids: Array[int] = []
#
#func _ready():
	#initialize_tiles()
	#initialize_grid()
	#collapse()
	#generate()
	#
#func initialize_tiles():
	#tile_ids.clear()
	#tile_terrain.clear()
	#
	#for index in tile_set.get_terrains_count(0) : ## 0 = first terrain layer
		#var terrain = tile_set.get_terrain_name(0,index)  
		#if !terrain==null:
			#tile_ids.append(index)
			#tile_terrain[index] = terrain
					#
					#
#func initialize_grid():
	#grid = []
	#possible_tiles = []
	#for y in range(grid_size.y):
		#var row = []
		#var row_possible = []
		#for x in range(grid_size.x):
			#row.append(null)
			#row_possible.append(tile_ids.duplicate())
		#grid.append(row)
		#possible_tiles.append(row_possible)
#
#func collapse():
	#while true:
		#var lowest_entropy = null
		#var lowest_positions = []
#
		#for y in range(grid_size.y):
			#for x in range(grid_size.x):
				#if grid[y][x] == null:
					#var entropy = possible_tiles[y][x].size()
					#if entropy == 0:
						#push_error("Contradiction found: No possible tiles!")
						#return
					#if lowest_entropy == null or entropy < lowest_entropy:
						#lowest_entropy = entropy
						#lowest_positions = [Vector2i(x, y)]
					#elif entropy == lowest_entropy:
						#lowest_positions.append(Vector2i(x, y))
#
		#if lowest_positions.is_empty():
			#break
#
		#var pos = lowest_positions[randi() % lowest_positions.size()]
		#var x = pos.x
		#var y = pos.y
#
		#var selected_tile_id = possible_tiles[y][x][randi() % possible_tiles[y][x].size()]
		#grid[y][x] = selected_tile_id
		#possible_tiles[y][x] = [selected_tile_id]
#
		#propagate(x, y)
#
#
### TODO : Set up the proper rules for our propagation
#func propagate(x: int, y: int):
	#var directions = [
		#Vector2i(1, 0),
		#Vector2i(-1, 0),
		#Vector2i(0, 1),
		#Vector2i(0, -1)
	#]
	#var current_tile_id = grid[y][x]
	#if current_tile_id == null:
		#return
#
	#var current_terrain = tile_terrain.get(current_tile_id, null)
	#if current_terrain == null:
		#return
#
	#for dir in directions:
		#var nx = x + dir.x
		#var ny = y + dir.y
		#if nx >= 0 and nx < grid_size.x and ny >= 0 and ny < grid_size.y:
			#if grid[ny][nx] == null:
				#var new_possible_tiles = []
				#for possible_tile_id in possible_tiles[ny][nx]:
					#var possible_terrain = tile_terrain.get(possible_tile_id, null)
					#if possible_terrain == current_terrain:
						#new_possible_tiles.append(possible_tile_id)
#
				#if not new_possible_tiles.is_empty():
					#possible_tiles[ny][nx] = new_possible_tiles
#
#
#func generate():
	#for y in range(grid_size.y):
		#for x in range(grid_size.x):
			#var tile_id = grid[y][x]
			#if tile_id != null:
				#self.set_cell()

class_name LevelGenerator extends Node2D

@export var main : TileMapLayer
@export var deco : TileMapLayer
@export var wfc_generator : WFC2DGenerator
@export var collectable_ref : PackedScene
@export var collectable_holder : Node

# TODO: Find a better way of utilizing these, may just reduce to 2.
var lush := FastNoiseLite.new()
var humidity := FastNoiseLite.new()
var wind_speed := FastNoiseLite.new()

func _ready() -> void:
	$sample.hide()
	$target.show()
	_generate_biomes()

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
			if deco.get_cell_tile_data(Vector2i(x, y)):
				var collectable : InteractableTile = collectable_ref.instantiate()
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
	var check_area := [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1, 0), Vector2i(1, 0),
		Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1),
	]
	
	for area in check_area:
		var checked_tile = main.get_cell_tile_data(pos + area)
		if checked_tile and main.get:
			if terrain_id != checked_tile.terrain:
				return false
	
	return true

func _on_wfc_finished() -> void:
	GameGlobalEvents.map_generated.emit()
	$progressIndicator.hide()
