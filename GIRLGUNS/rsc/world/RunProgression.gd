extends Node2D
class_name RunProgression

@export var progs : Array[Progression] = []
@export var distance_from_player : float = 2000
@export_group("scaling")
@export var scale_delay : float = 10
@export var hp_scale : float = 0.1
@export var speed_scale : float = 0.1

var hp_mult : float = 1
var speed_mult : float = 1

var active : bool = false
var next_prog : float = 0
var next_spawn : float = 0

var scale_active : bool = true
var next_scale : float = 0

var raw_time : float = 0
var time : Vector2i = Vector2i(0,0)



func start():
	if progs.size() > 0:
		next_prog = convert_to_raw(progs[0].duration)
		next_spawn = progs[0].delay

func _physics_process(delta: float) -> void:
	if progs.size() == 0:
		active = false
	if active:
		timer(delta)
	
	if raw_time > next_spawn:
		progress_spawn(progs[0])
		next_spawn += progs[0].delay

	if raw_time > next_prog:
		prog_end()
	
	if raw_time > next_scale:
		scale_up()

func convert_to_raw(vec : Vector2i) -> float:
	return float(vec.x * 60) + float(vec.y)

func timer(delta):
	raw_time += delta
	time.x = floor(raw_time/60)
	time.y = floor(raw_time) % 60

func rand_spawn_point() -> Vector2:
	var distance = Globals.rng.randf_range(800,1200)
	var angle = Globals.rng.randf_range(0,2 * PI)
	return Globals.player.global_position + (Vector2.from_angle(angle) * distance)


func progress_spawn(prog : Progression):
	var new_enemy : Enemy
	for n in range(0,prog.enemies.size()):
		for count in range(0,prog.spawn_count[n]):
			new_enemy = Globals.add_enemy(prog.enemies[n].instantiate())
			new_enemy.global_position = rand_spawn_point()
			new_enemy.look_at(Globals.player.global_position)
			modify_enemy(new_enemy)
			new_enemy.spawn()
	
func prog_end(force : bool = false):
	if force or progs.size() > 0:
		progs.remove_at(0)

	next_prog += convert_to_raw(progs[0].duration)
	next_spawn = next_prog + progs[0].delay

func modify_enemy(enemy : Enemy):
	enemy.base_max_hp *= hp_mult
	enemy.base_speed *= speed_mult
	return

func scale_start():
	scale_active = true
	next_scale = raw_time + scale_delay

func scale_up():
	hp_mult *= (1 + hp_scale)
	speed_scale *= (1 + speed_scale)
	next_scale += scale_delay
	

