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

extends Node2D


func _ready() -> void:
	$sample.hide()
	$target.show()
	$WFC2DGenerator.start()
