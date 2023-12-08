extends Node2D
class_name Projectile

@export_enum("Projectile", "HitScan") var type = 0
@export var piercing : bool = false

var active : bool = false
@export var hitbox : Area2D

func activate():
	active = true


func _process(delta: float) -> void:
	pass
