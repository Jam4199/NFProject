@tool
extends Node2D

@export var distance : float = 0 : set = set_distance
@export var exception : Node2D


@onready var up = get_node("up")
@onready var down = get_node("down")
@onready var left = get_node("left")
@onready var right = get_node("right")

func _ready() -> void:
	if exception != null:
		for directions in [up,down,left,right]:
			directions.add_exception(exception)

func set_distance(new_distance):
	distance = new_distance
	
	if has_node("up"):
		get_node("up").target_position.y = -(distance)
	
	if has_node("down"):
		get_node("down").target_position.y = (distance)
	
	if has_node("left"):
		get_node("left").target_position.x = -(distance)
	
	if has_node("right"):
		get_node("right").target_position.x = (distance)

func border_check(direction : Vector2) -> Vector2:
	
	var x = direction.x
	if x > 0 and right.get_collider() != null:
		direction.x = 0
	if x < 0 and left.get_collider() != null:
		direction.x = 0
	
	var y = direction.y
	if y > 0 and down.get_collider() != null:
		direction.y = 0
	if y < 0 and up.get_collider() != null:
		direction.y = 0
	direction = direction.normalized()
	
	return direction
