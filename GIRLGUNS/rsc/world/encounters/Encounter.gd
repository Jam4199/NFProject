extends Node2D

var waves : Array[EncounterWave]

var active : bool = false
var time_elapsed : float = 0

func _ready() -> void:
	for child in get_children():
		if child is EncounterWave:
			waves.append(EncounterWave)
		
	return

func _physics_process(delta: float) -> void:
	if not active:
		return
	time_elapsed += delta
	for wave in waves:
		if wave.spawn_time > time_elapsed and not wave.spawned:
			spawn_wave(wave) 
		if wave.effect_time > time_elapsed and not wave.effected:
			spawn_effect(wave)

func spawn_wave(wave : EncounterWave):
	for n in range(0,wave.enemy_spawns.size()):
		wave.remove_child(wave.enemy_spawns[n])
		Globals.add_enemy(wave.enemy_spawns[n])
		wave.enemy_spawns[n].global_position = wave.spawn_pos[n]
		wave.enemy_spawns[n].global_rotation = wave.spawn_rot[n]
		wave.enemy_spawns[n].process_mode = PROCESS_MODE_INHERIT
	wave.custom_post_spawn()
	return

func spawn_effect(wave : EncounterWave):
	for n in range(0,wave.effect_spawns.size()):
		wave.remove_child(wave.effect_spawns[n])
		Globals.add_effect(wave.effect_spawns[n],false)
		wave.effect_spawns[n].global_position = wave.effect_pos[n]
		wave.effect_spawns[n].global_rotation = wave.effect_rot[n]
		wave.effect_spawns[n].process_mode = PROCESS_MODE_INHERIT
	return
