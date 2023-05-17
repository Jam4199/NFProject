extends Node2D
class_name PlayerControl


@export var movementcontrol : Node2D
@export var rotatecontrol : Node2D
@export var weaponcontrol : Node2D

signal direction_made
signal move_command(direction : Vector2)
signal rotate_command(direction : Vector2)

signal melee_pressed
signal melee_released
signal ranged_pressed
signal ranged_released

var direction = Vector2()

func _ready() -> void:
	connect("move_command",Callable(movementcontrol,"move_command"))
	

func _physics_process(delta: float) -> void:
	
	
	direction.x = Input.get_axis("player_left", "player_right")
	direction.y = Input.get_axis("player_up", "player_down")
	emit_signal("direction_made")
	
	emit_signal("move_command", direction)
	emit_signal("rotate_command", direction)
	
	if Input.is_action_just_pressed("player_melee"):
		emit_signal("melee_pressed")
	if Input.is_action_just_released("player_melee"):
		emit_signal("melee_released")
	
	if Input.is_action_just_released("player_ranged"):
		emit_signal("ranged_pressed")
	if Input.is_action_just_released("player_ranged"):
		emit_signal("ranged_released")



