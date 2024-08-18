extends Node
class_name CityData

var grid_data : Array[BlockData]

func _ready() -> void:
	initialize_grid()
	

func initialize_grid():
	grid_data.resize(100)
	for n in range(0,grid_data.size()):
		var new_block = BlockData.new()
		match n: # y-x
			72,73,74:
				new_block = BlockData.BLOCKS.PORT
			62,63,64,65,52,53,54,55: #south district
				new_block = BlockData.BLOCKS.SIDE
			4,5,6.14,15,16,25,26: #north district
				new_block = BlockData.BLOCKS.SIDE
			23, 33, 43, 34, 44, 45:
				new_block = BlockData.BLOCKS.CENTER
			7,17,27,46,56,66,77,78:
				new_block = BlockData.BLOCKS.BEACH
			88:
				new_block = BlockData.BLOCKS.LIGHT
			_:
				new_block.block_type = BlockData.BLOCKS.EMPTY
	
	
	
