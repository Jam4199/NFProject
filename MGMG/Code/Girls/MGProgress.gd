extends Node
class_name MGProgress

@onready var pink : MGInfo = get_node("Pink")
@onready var blue : MGInfo = get_node("Blue")
@onready var yellow : MGInfo = get_node("Yellow")
@onready var white : MGInfo = get_node("White")

var white_unlocked : bool = false

func tic():
	for child in [pink,blue,yellow]:
		child.tic()
	if white_unlocked:
		white.tic()
	
	
