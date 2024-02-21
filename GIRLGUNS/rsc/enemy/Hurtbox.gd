extends Area2D
class_name HurtBox

@export var constant_hit : bool = false
@export var damage : float = 100

@export_group("Visuals")
@export var hit_effect : PackedScene
@export var end_effect : PackedScene

var already_hit : bool = false

func _ready() -> void:
	return

func activate():
	already_hit = false
	set_deferred("monitorable",true)

func hit(player : Player):
	if already_hit:
		return
	player.take_damage(damage)
	if hit_effect != null:
		var new_effect = hit_effect.instantiate()
		Globals.add_effect(new_effect)
	if not constant_hit:
		already_hit = true
	return

func deactivate():
	set_deferred("monitorable",true)
