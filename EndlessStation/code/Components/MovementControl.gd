extends Node2D
class_name MovementControl

var static_delta : float

@export var base_movement_speed : float = 20
@export var focus_speed_multiplier : float = 0.5
@export var character : Node2D



var unit : Node2D = self.owner
var direction := Vector2(0,0)
var speed_multiplier : float = 1

var focus : bool = false : set = set_focus

signal speed_update_check
signal destination_check


func set_focus(new_focus : bool):
	focus = new_focus
	update_speed()


func _ready() -> void:
	static_delta = Settings.static_delta
	
	
	if character != null:
		unit = character


func update_speed():
	match focus:
		false:
			speed_multiplier = 1
		true:
			speed_multiplier = focus_speed_multiplier
	emit_signal("speed_update_check")

func _physics_process(delta: float) -> void:
	if direction == Vector2(0,0):
		return
	
	if unit == null:
		print("no unit")
		return
	
	var velocity = direction * base_movement_speed * speed_multiplier * static_delta
	
	unit.global_position += velocity


func move_command(new_direction : Vector2):
	direction = new_direction.normalized()
	
