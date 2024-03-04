extends Enemy

@export var lifetime : float = 3
@export_group("spawn_data")
@export var spawn_scene : PackedScene
@export var max_spawns : int = 1
@export var initial_delay : float = 1
@export var spawn_delay : float = 1
@export_enum("RANDO","PLAYER","DIRECTION") var spawn_rotation : int = 0

var spawned : bool = false
var life_timer : float
var spawn_count : int
var delay_timer : float
var initial_delayed : bool = false

func spawn():
	super()
	spawned = true
	life_timer = lifetime
	delay_timer = initial_delay
	spawn_count = 0


func _physics_process(delta: float) -> void:
	super(delta)
	life_timer -= delta
	delay_timer -= delta
	if delay_timer <= 0:
		spawn_enemy()
	
	

func spawn_enemy():
	if spawn_count >= max_spawns:
		return
	var new_enemy : Enemy = spawn_scene.instantiate()
	Globals.add_enemy(new_enemy)
	new_enemy.global_position = global_position
	match spawn_rotation:
		0:
			new_enemy.global_rotation_degrees = Globals.rng.randf_range(0,360)
		1:
			new_enemy.look_at(Globals.player.global_position)
		2:
			new_enemy.global_rotation = global_rotation
	new_enemy.spawn()
	
