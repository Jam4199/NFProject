extends Node2D
class_name Death

@export var death_target : Node

signal death_trigger

func health_zero():
	if death_target == null:
		return
	emit_signal("death_trigger")
	death_target.queue_free()
