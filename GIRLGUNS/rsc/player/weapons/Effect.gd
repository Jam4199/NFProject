extends Node2D
class_name Effect

@onready var timer : Timer = get_node("Timer")

func _ready() -> void:
	timer.connect("timeout",Callable(self,"queue_free"))
	for child in get_children():
		if child is CPUParticles2D:
			child.emitting = true
