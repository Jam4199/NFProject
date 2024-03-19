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
	return

func spawn_player():
	player_layer.add_child(Globals.player)
	Globals.player.global_position = player_spawn_point.global_position

func enemy_death(dead : Enemy):
	if dead.kill_counted:
		kill_count += 1
	var exp5s : int = floori(float(dead.exp)/5.0)
	var exp1s : int = dead.exp % 5
	for n in exp5s:
		var new_pickup : Pickup = EXP.instantiate()
		pickup_layer.add_child(new_pickup)
		new_pickup.global_position = dead.global_position + ((Vector2.from_angle(Globals.rng.randf_range(0,PI)) * Globals.rng.randf_range(-20,20)))
	for n in exp1s:
		var new_pickup : Pickup = EXP.instantiate()
		pickup_layer.add_child(new_pickup)
		new_pickup.global_position = dead.global_position + ((Vector2.from_angle(Globals.rng.randf_range(0,PI)) * Globals.rng.randf_range(-20,20)))
	for n in dead.heal:
		var new_pickup : Pickup = HEAL.instantiate()
		pickup_layer.add_child(new_pickup)
		new_pickup.global_position = dead.global_position + ((Vector2.from_angle(Globals.rng.randf_range(0,PI)) * Globals.rng.randf_range(-20,20)))

	return

func pause():
	process_mode = Node.PROCESS_MODE_DISABLED
	return

func unpause():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	return
