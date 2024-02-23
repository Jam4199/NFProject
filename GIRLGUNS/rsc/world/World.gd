extends Node2D
class_name World

@onready var player_layer : Node2D = get_node("%PlayerLayer")
@onready var bullet_layer : Node2D = get_node("%BulletLayer")
@onready var effect_layer : Node2D = get_node("%EffectLayer")
@onready var enemy_layer_large : Node2D = get_node("%EnemyLayerLarge")
@onready var enemy_layer_mid : Node2D = get_node("%EnemyLayerMid")
@onready var enemy_layer_small : Node2D = get_node("%EnemyLayerSmall")
@onready var world_camera : Camera2D = get_node("WorldCamera")

var player_control : bool = false

func _ready() -> void:
	
	return

func add_bullet(new_bullet : Bullet):
	if bullet_layer == null:
		return
	bullet_layer.add_child(new_bullet)

func add_effect(new_effect : Node2D):
	if effect_layer == null:
		return
	effect_layer.add_child(new_effect)

func add_enemy(new_enemy : Enemy):
	match new_enemy.world_layer:
		0:
			enemy_layer_large.add_child(new_enemy)
		1:
			enemy_layer_mid.add_child(new_enemy)
		2: 
			enemy_layer_small.add_child(new_enemy)
	return

func _physics_process(delta: float) -> void:

	return

func spawn_player():
	player_layer.add_child(Globals.player)
	Globals.player.global_position = get_node("%PlayerSpawnPoint").global_position
	

