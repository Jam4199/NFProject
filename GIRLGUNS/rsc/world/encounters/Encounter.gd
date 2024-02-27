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
		if wave.spawned:
			continue
		if wave.spawn_time > time_elapsed:
			spawn_wave(wave) 
		

func spawn_wave(wave : EncounterWave):
	for n in range(0,wave.enemy_spawns.size()):
		wave.remove_child(wave.enemy_spawns[n])
		Globals.add_enemy(wave.enemy_spawns[n])
		wave.enemy_spawns[n].global_position = wave.spawn_pos[n]
	wave.custom_post_spawn()
	return

