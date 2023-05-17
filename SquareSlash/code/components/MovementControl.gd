extends Node2D
class_name MovementControl

@export var base_movement_speed : float = 20
@export var character : CharacterBody2D
@export var slide : bool = false


var unit : CharacterBody2D = self.owner
var direction := Vector2(0,0)
var speed_multiplier : float = 1



signal speed_update_check
signal destination_check



func _ready() -> void:
	if character != null:
		unit = character



func update_speed():
	speed_multiplier = 1
	emit_signal("speed_update_check")


func _physics_process(delta: float) -> void:
	if direction == Vector2(0,0):
		return
	
	if unit == null:
		print("no unit")
		return
	
	var velocity = direction * base_movement_speed * speed_multiplier
	
	unit.velocity = velocity
	if slide:
		unit.move_and_slide()
	else:
		unit.move_and_collide(velocity * delta)
	


func move_command(new_direction : Vector2):
	direction = new_direction.normalized()
	
