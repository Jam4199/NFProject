extends Node2D
class_name EncounterWave

@export_range(0,20) var effect_time : float = 0
@export_range(0,20) var spawn_time : float = 1

var effect_spawns : Array[Effect] = []
var effect_pos : Array[Vector2] = []
var effect_rot : Array[float] = []
var effected : bool = false

var enemy_spawns : Array[Enemy] = []
var spawn_pos : Array[Vector2] = []
var spawn_rot : Array[float] = []
var spawned : bool = false

var effects

func _ready() -> void:
	for child in get_children():
		if child is Enemy:
			enemy_spawns.append(child)
			spawn_pos.append(child.global_position)
			spawn_rot.append(child.global_rotation)
		if child is Effect:
			effect_spawns.append(child)
			effect_pos.append(child.global_position)
			effect_rot.append(child.global_rotation)
		child.process_mode = PROCESS_MODE_DISABLED
	return

func custom_post_spawn():
	return
