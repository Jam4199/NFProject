extends Node
class_name DpadControl

@export var active : bool = true
@export var target : Node

signal move_ordered(direction : Vector2)

func _ready() -> void:
	
	if target == null:
		if owner == null:
			target = owner
		else:
			if get_parent().has_method("move_order"):
				target = get_parent()
			else:
				target = owner
	
	if target.has_method("move_order"):
		connect("move_ordered", Callable(target,"move_order"))
	else:
		print("no target: " + str(get_path() ) )
	
	

func _physics_process(delta: float) -> void:
	var direction = Vector2()
	direction.x = Input.get_axis("player_left", "player_right")
	direction.y = Input.get_axis("player_up", "player_down")
	emit_signal("move_ordered", direction)
	

