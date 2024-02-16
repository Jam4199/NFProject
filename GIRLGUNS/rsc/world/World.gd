extends Node2D
class_name World

@onready var bullet_layer = get_node("%BulletLayer")
@onready var effect_layer = get_node("%EffectLayer")

func _ready() -> void:
	return

func add_bullet(new_bullet : Bullet):
	if bullet_layer == null:
		return
	bullet_layer.add_child(new_bullet)

func add_effect(new_effect : Node2D):
	if effect_layer == null:
		return
	effect_layer.add_child(new_effect)
