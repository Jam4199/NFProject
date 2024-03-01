extends Area2D

@export var healing : float = 0
@export var attract_accel : float = 800
@export var attract_max_speed : float = 1000


var attracted : bool = false
var inertia : Vector2 = Vector2(0,0)

func _physics_process(delta):
	if attracted and Globals.player != null:
		var accel :Vector2 = Vector2.from_angle(global_position.angle_to_point(Globals.player.global_position)) * (attract_accel * delta)
		inertia += accel
		inertia = inertia.limit_length(attract_max_speed)
		global_position += inertia
	else:
		inertia = Vector2(0,0)
		return
	
	return

func picked_up(body:Node2D):
	return




















