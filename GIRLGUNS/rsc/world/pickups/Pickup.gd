extends Area2D
class_name Pickup

@export_enum("Heal","Exp","Energy") var type : int = 0
@export var value : float
@export var attract_accel : float = 50
@export var attract_max_speed : float = 400
@export var pick_effect : PackedScene


var attracted : bool = false
var current_speed : float = 80

func _physics_process(delta):
	if attracted and Globals.player != null:
		current_speed += attract_accel * delta
		var velocity : Vector2 = Vector2.from_angle(global_position.angle_to_point(Globals.player.global_position)) * current_speed
		
		global_position += velocity
	else:
		var velocity : Vector2 = Vector2.from_angle(global_position.angle_to_point(Globals.player.global_position)) * current_speed
		global_position += velocity
		return
	
	return

func picked_up(body:Node2D):
	if pick_effect != null:
		var new_effect = pick_effect.instantiate()
		Globals.add_effect(new_effect)
		new_effect.global_position = global_position
	hide()
	set_deferred("monitorable",false)
	set_deferred("attracted", false)
	return




















