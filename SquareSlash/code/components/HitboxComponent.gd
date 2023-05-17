extends Area2D
class_name HitBox

@export var damage_reciever : Node

signal bullet_hit

func _ready() -> void:
	connect("area_entered", Callable(self, "attack_check"))

func attack_check(area : Area2D):
	
	pass

