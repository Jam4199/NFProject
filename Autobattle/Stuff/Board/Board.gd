@tool
class_name Board
extends Node

@export var width : int = 1 : set = set_width
@export var height : int = 1 : set = set_height

func _ready() -> void:
	build()


var grid : Array = []

func set_width(new_width : int):
	if new_width < 1:
		new_width = 1
	
	if new_width != width:
		width = new_width
		rebuild()

func set_height(new_height : int):
	
	if new_height < 1:
		new_height = 1
	
	if new_height != height:
		height = new_height
		rebuild()
	

func build():
	for x in width:
		grid.append([])
		for y in height:
			grid[x].append(BoardTile.new())

func rebuild():
	if grid == []:
		build()
		return
	
	var new_grid : Array = []
	
	var old_width : int = grid.size()
	var old_height : int = grid[0].size()
	
	for x in width:
		new_grid.append([])
		for y in height:
			if x < old_width and y < old_height:
				new_grid[x].append(grid[x][y])
			else:
				new_grid[x].append(BoardTile.new())
	
	grid = new_grid

func compute_paths(center : Vector2i, steps : int, movement_data : Resource = null, results : Dictionary = {}):
	if results.has(str(center)):
		if results[str(center)]["steps"] < steps:
			results[str(center)]["steps"] = steps
	else:
		results[str(center)] = {}
		results[str(center)]["steps"] = steps
		results[str(center)]["point"] = center
	
	if steps <= 0:
		print("end at " + str(center))
		return results
	
	for point in get_surrounding_points(center):
		var tile : BoardTile = grid[point.x][point.y]
		if results.has(str(point)):
			if results[str(point)]["steps"] >= (steps - tile.default_entry_cost):
				continue
		compute_paths(point, steps - tile.default_entry_cost, movement_data, results)
	
	return results

func get_surrounding_points(center : Vector2i) -> Array:
	var surrounding_points : Array = []
	for point in [
		Vector2i(center.x +1,center.y),
	Vector2i(center.x - 1, center.y), 
	Vector2i(center.x,center.y - 1), 
	Vector2i(center.x, center.y + 1)
	]:
		if is_point_valid(point):
			surrounding_points.append(point)
	
	return surrounding_points

func is_point_valid(point : Vector2) -> bool:
	if point.x < 0 or point.x >= width:
		return false
	if point.y < 0 or point.y >= height:
		return false
	return true












