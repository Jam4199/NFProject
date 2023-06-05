extends Node2D
class_name Death

@export var death_target : Node

func health_zero():
	if death_target == null:
		return
	
	death_target.queue_free()
