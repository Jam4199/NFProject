extends Node2D

@onready var board : Board = get_node("Board")

func _ready() -> void:
	var points : Dictionary = board.compute_paths(Vector2i(5,5), 10)
	print(str(points.keys()))
	print(str(points.size()))
	
