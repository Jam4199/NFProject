extends Node2D
class_name EnemyWeapon

@export var bullet_scene : PackedScene
@export var cooldown_time : float = 1

@export var bullet_damage_mult : float = 1
@export var bullet_speed_mult : float = 1

var cooldown_timer : float = cooldown_time

func _ready() -> void:
	cooldown_timer = cooldown_time

func _physics_process(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta

func shoot(force : bool = false) -> EnemyBullet:
	if cooldown_time <= 0 and force == false:
		return
	var new_bullet : EnemyBullet = bullet_scene.instantiate()
	Globals.add_enemy_bullet(new_bullet)
	new_bullet.global_position = global_position
	new_bullet.global_rotation = global_rotation
	cooldown_timer = cooldown_time
	new_bullet.damage *= bullet_damage_mult
	new_bullet.speed *= bullet_speed_mult
	return new_bullet





