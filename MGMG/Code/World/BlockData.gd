extends Resource
class_name BlockData

var block_type : BLOCKS = BLOCKS.EMPTY : set = set_block_type
enum BLOCKS {EMPTY, PORT, SIDE, CENTER, BEACH, BRIDGE, FOREST, LIGHT}
var max_hp : float = 100
var hp : float = 100

func set_block_type(new_block):
	if block_type == new_block:
		return
	block_type = new_block
	match new_block:
		BLOCKS.EMPTY:
			max_hp = 100
			hp = 100
		BLOCKS.PORT:
			max_hp = 1000
			hp = 1000
		BLOCKS.SIDE:
			max_hp = 1400
			hp = 1400
		BLOCKS.CENTER:
			max_hp = 1800
			hp = 1800
		BLOCKS.BEACH:
			max_hp = 500
			hp = 500
		BLOCKS.BRIDGE:
			max_hp = 1000
			hp = 1000
		BLOCKS.FOREST:
			max_hp = 1400
			hp = 1400
		BLOCKS.LIGHT:
			max_hp = 800
			hp = 800
