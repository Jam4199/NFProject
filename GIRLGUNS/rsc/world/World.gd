extends Node2D
class_name World

const EXP = preload("res://rsc/world/pickups/Exp.tscn")
const EXP5 = preload("res://rsc/world/pickups/5Exp.tscn")
const HEAL = preload("res://rsc/world/pickups/Heal.tscn")


@onready var pickup_layer : Node2D = get_node("%PickupLayer")
@onready var player_layer : Node2D = get_node("%PlayerLayer")
@onready var bullet_layer : Node2D = get_node("%BulletLayer")
@onready var effect_layer : Node2D = get_node("%EffectLayer")
@onready var player_spawn_point : Node2D = get_node("%PlayerSpawnPoint")
@onready var back_effect_layer : Node2D = get_node("%BackEffectLayer")
@onready var enemy_layer_large : Node2D = get_node("%EnemyLayerLarge")
@onready var enemy_layer_mid : Node2D = get_node("%EnemyLayerMid")
@onready var enemy_layer_small : Node2D = get_node("%EnemyLayerSmall")
@onready var world_camera : Camera2D = get_node("WorldCamera")
@onready var bordershow : Sprite2D = get_node("BorderShowizer")
@onready var borderline : Line2D = get_node("BorderShowizer/BorderLine")

@onready var upgrades : Node = get_node("Upgrades")
@onready var runprogress : RunProgression = get_node("%RunProgression")


var player_control : bool = false
var kill_count : int = 0
var boss_count : int = 0

var pqueue : Array = []
var max_p_per_frame : int = 10

func _ready() -> void:
	
	return

func initialize():
	upgrades.initialize()

func add_bullet(new_bullet : Bullet):
	if bullet_layer == null:
		return
	bullet_layer.add_child(new_bullet)

func add_effect(new_effect : Node2D,front : bool = true):
	if front:
		if effect_layer == null:
			return
		effect_layer.add_child(new_effect)
		return
	else:
		if back_effect_layer == null:
			return
		back_effect_layer.add_child(new_effect)
		return

func add_enemy(new_enemy : Enemy):
	if new_enemy.boss:
		boss_count += 1
	match new_enemy.world_layer:
		0:
			enemy_layer_large.add_child(new_enemy)
		1:
			enemy_layer_mid.add_child(new_enemy)
		2: 
			enemy_layer_small.add_child(new_enemy)
	return

func add_enemy_bullet(new_bullet : EnemyBullet):
	match new_bullet.world_layer:
		0:
			enemy_layer_large.add_child(new_bullet)
		1:
			enemy_layer_mid.add_child(new_bullet)
		2: 
			enemy_layer_small.add_child(new_bullet)
	return

func _physics_process(delta: float) -> void:
	if Globals.player != null:
		bordershow.global_position = Globals.player.global_position
	borderline.global_position = global_position
	if pqueue.size() > 0:
		pqueue_create()
	if Input.is_action_just_pressed("pause_game") and Globals.player.attack_input:
		call_deferred("player_pause")
	return

func spawn_player():
	player_layer.add_child(Globals.player)
	Globals.player.global_position = player_spawn_point.global_position

func enemy_death(dead : Enemy):
	
	if dead.kill_counted:
		kill_count += 1
	if dead.boss:
		boss_count -= 1
	pqueue_add(dead.global_position,dead.exp,dead.world_layer)
	var drop_distance : float = (dead.world_layer + 1) * 15
	for n in dead.heal:
		var new_pickup : Pickup = HEAL.instantiate()
		pickup_layer.add_child(new_pickup)
		new_pickup.global_position = dead.global_position + ((Vector2.from_angle(Globals.rng.randf_range(0,2 * PI)) * Globals.rng.randf_range(0,drop_distance)))
	return

func pqueue_add(p_position : Vector2 , p_value : int, size : int):
	var new_p : Array = [p_position,p_value, size]
	pqueue.append(new_p)
	return

func pqueue_create():
	var cap : int = max_p_per_frame
	var current : int = 0
	var exp5s : int
	var exp1s : int
	for p in pqueue:
		exp5s = floori(float(p[1]) / 5.0)
		exp1s = p[1] % 5
		for n in exp5s:
			var new_pickup : Pickup = EXP5.instantiate()
			var drop_distance : float = (p[2] + 1) * 15
			pickup_layer.add_child(new_pickup)
			new_pickup.global_position = p[0] + ((Vector2.from_angle(Globals.rng.randf_range(0,2 * PI)) * Globals.rng.randf_range(0,drop_distance)))
			current += 1
			if current >= cap:
				new_pickup.value += ((exp5s - n - 1) * 5) + exp1s
				break
		if current >= cap:
			continue
		for n in exp1s:
			var new_pickup : Pickup = EXP.instantiate()
			pickup_layer.add_child(new_pickup)
			new_pickup.global_position = p[0] + ((Vector2.from_angle(Globals.rng.randf_range(0,PI)) * Globals.rng.randf_range(-20,20)))
			current += 1
			if current >= cap:
				new_pickup.value += (exp1s - n - 1)
				break
		
	pqueue = []
	return

func player_pause():
	if process_mode == Node.PROCESS_MODE_DISABLED:
		return
	pause()
	Globals.player_pause()

func pause():
	process_mode = Node.PROCESS_MODE_DISABLED
	return

func unpause():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	return
