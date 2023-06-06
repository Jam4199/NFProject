extends Area2D
class_name Hurtbox

@export var damage : float = 0


signal hurtbox_hit

func hit():
	emit_signal("hurtbox_hit")
