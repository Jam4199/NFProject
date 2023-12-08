extends Node2D
class_name VFX

@export_group("Lifetime")
@export var auto_free : bool = true
@export var auto_free_timer : float = 10

signal vfx_played

func _ready() -> void:
	for child in get_children():
		if child.has_method("vfx_play"):
			connect("vfx_played",Callable(child,"vfx_play"))
	if auto_free and auto_free_timer > 0:
		var death_timer = Timer.new()
		death_timer.wait_time = auto_free_timer
		death_timer.connect("timeout",Callable(self,"queue_free"))
		



func vfx_play():
	emit_signal("vfx_played")
