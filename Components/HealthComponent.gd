extends Node
class_name HealthComponent

@export var max_health : float = 1000
@export var prevent_negative_health : bool = true

@export var death : Node

var health
var damage_immune = false

signal damage_taken_full
signal damage_taken_capped
signal health_zeroed
signal health_changed

func _ready() -> void:
	health = max_health
	if death != null:
		if death.has_method("health_zero"):
			connect("health_zero", Callable(death, "health_zero")) 

func set_health(new_health : float):
	health = new_health
	emit_signal("health_changed", health)

func take_damage(damage : float):
	
	if damage_immune or damage == 0 :
		print("no damage")
		return 
	print("take_damage " + str(damage) )
	emit_signal("damage_taken_full", damage)
	if damage > max_health and prevent_negative_health:
		damage = max_health
	emit_signal("damage_taken_capped", damage)
	set_health(health - damage)
	if health <= 0:
		emit_signal("health_zero")
	else:
		print("remaining_health " + str(health))

