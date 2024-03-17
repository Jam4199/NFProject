@tool
extends Node2D
class_name RunProgression

@export var progs : Array[Progression] = [] : set = set_prog
@export var total_time : float = 0
@export var distance_from_player : float = 2000
@export var heal_drop_rate : float = 0.5 # /100
@export_group("scaling")
@export var scale_delay : float = 10
@export var hp_scale : float = 0.1
@export var speed_scale : float = 0.1

func set_prog(new_prog):
	progs = new_prog
	total_time = 0
	for prog in progs:
		if prog != null:
			total_time += prog.duration.y + (prog.duration.x * 60) 
	notify_property_list_changed()

var hp_mult : float = 1
var speed_mult : float = 1

var active : bool = false
var next_prog : float = 0
var next_spawn : float = 0
var current_round : int = 0

var scale_active : bool = true
var next_scale : float = 0

var raw_time : float = 0
var time : Vector2i = Vector2i(0,0)



func start():
	if progs.size() > 0:
		print(str(progs[current_round]))
		active = true
		current_round = 0
		next_prog = convert_to_raw(progs[current_round].duration)
		print("next prog is" + str(next_prog))
		next_spawn = progs[current_round].delay
		print("next spawn is" + str(next_spawn))
	else:
		print("cant start")

func _physics_process(delta: float) -> void:
	if progs.size() == 0:
		active = false
		print("end")
	if active:
		timer(delta)
	
	if raw_time > next_spawn:
		print("please spawn")
		progress_spawn(progs[current_round])
		next_spawn += progs[current_round].delay
		print(str(next_spawn))

	if raw_time > next_prog:
		prog_end()
		print(str(next_prog))
		print("delay to " +  str(next_spawn))
	
	if raw_time > next_scale:
		scale_up()

func convert_to_raw(vec : Vector2i) -> float:
	return float(vec.x * 60) + float(vec.y)

func timer(delta):
	raw_time += delta
	time.x = floori(raw_time/60)
	time.y = floori(raw_time) % 60

func rand_spawn_point() -> Vector2:
	var distance = Globals.rng.randf_range(800,1200)
	var angle = Globals.rng.randf_range(0,2 * PI)
	return Globals.player.global_position + (Vector2.from_angle(angle) * distance)


func progress_spawn(prog : Progression):
	
	print("spawn")
	for n in range(0,prog.enemies.size()):
		
		for count in range(0,prog.spawn_count[n]):
			var new_enemy : Enemy = Globals.add_enemy(prog.enemies[n].instantiate())
			new_enemy.global_position = rand_spawn_point()
			new_enemy.look_at(Globals.player.global_position)
			modify_enemy(new_enemy)
			new_enemy.spawn()
			print("spawned smth")
	
func prog_end(force : bool = false):
	current_round += 1
	if not force and progs.size() >= current_round:
		current_round = progs.size() - 1
	next_spawn = next_prog + progs[current_round].delay
	next_prog += convert_to_raw(progs[current_round].duration)
	print(progs[current_round].text)

func modify_enemy(enemy : Enemy):
	enemy.base_max_hp *= hp_mult
	enemy.base_speed *= speed_mult
	if Globals.rng.randi_range(0,100) == 1:
		enemy.heal += 1
	return

func scale_start():
	scale_active = true
	next_scale = raw_time + scale_delay

func scale_up():
	hp_mult *= (1 + hp_scale)
	speed_scale *= (1 + speed_scale)
	next_scale += scale_delay
	

