extends Node2D

@export var playercontrol : PlayerControl

@onready var left : ShapeCast2D = get_node("-x")
@onready var right : ShapeCast2D = get_node("+x")
@onready var up : ShapeCast2D = get_node("-y")
@onready var down : ShapeCast2D = get_node("+y")

func _ready() -> void:
	if playercontrol == null:
		print("precollider missing playercontrol")
		return
	for cast in  [up,down,left,right]:
		cast.add_exception(owner)
		cast.collision_mask = owner.collision_mask
	playercontrol.connect("direction_made", Callable(self,"direction_checK"))


func direction_checK():
	if playercontrol == null:
		return
	var direction = playercontrol.direction
	
	var x = direction.x
	if x > 0 and right.is_colliding():
		direction.x = 0
	if x < 0 and left.is_colliding():
		direction.x = 0
	
	var y = direction.y
	if y > 0 and down.is_colliding():
		direction.y = 0
	if y < 0 and up.is_colliding():
		direction.y = 0
	playercontrol.direction = direction.normalized()
