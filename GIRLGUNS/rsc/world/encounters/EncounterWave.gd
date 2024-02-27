extends Node2D
class_name EncounterWave


@export_range(0,20) var spawn_time : float


var enemy_spawns : Array[Enemy]
var spawn_pos : Array[Vector2]
var spawned : bool = false

func _ready() -> void:
	for child in get_children():
		if child is Enemy:
			enemy_spawns.append(child)
			spawn_pos.append(child.global_position)
	return

func custom_post_spawn():
	return
