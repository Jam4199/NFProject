extends Area2D
class_name HitBox

@export var damage_reciever : Node

signal bullet_hit

func _ready() -> void:
	connect("area_entered", Callable(self, "area_check"))
	connect("bullet_hit", Callable(damage_reciever, "recieve_damage"))

func area_check(area : Area2D):
	return
	

