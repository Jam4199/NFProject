extends Node2D
class_name CircleThing

@export var radius : float = 10
@export var color : Color

func _draw() -> void:
	draw_circle(position,radius,color)
