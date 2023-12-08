extends Area2D
class_name HitBox

@export var health : Node

signal bullet_hit
signal deal_damage(damage : float)

func _ready() -> void:
	connect("area_entered", Callable(self, "area_check"))

	if health != null:
		
		connect("deal_damage", Callable(health,"take_damage"))

func area_check(area : Area2D):
	
	if area is Bullet:
		if self in area.pierced:
			return
		
		emit_signal("deal_damage", area.damage)
		area.hit(self)
		
	return
	

