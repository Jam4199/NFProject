extends Area2D
class_name HitBox

@export var damage_reciever : Node
@export var health : HealthComponent

signal bullet_hit
signal deal_damage(damage : float)

func _ready() -> void:
	connect("area_entered", Callable(self, "area_check"))
	if damage_reciever != null:
		connect("bullet_hit", Callable(damage_reciever, "recieve_damage"))
	if health != null:
		connect("deal_damage", Callable(health,"take_damage"))

func area_check(area : Area2D):
	if area is Hurtbox:
		emit_signal("deal_damage",area.damage)
		area.hit()
	return
	

