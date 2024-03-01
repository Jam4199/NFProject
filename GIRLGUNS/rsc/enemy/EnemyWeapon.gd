extends Node2D
class_name EnemyWeapon

@export var bullet_scene : PackedScene
@export var cooldown_time : float = 1

var cooldown_timer : float = 0

func _physics_process(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta

func shoot(force : bool = false) -> EnemyBullet:
	if cooldown_time <= 0 and force == false:
		return
	var new_bullet = bullet_scene.instantiate()
	Globals.add_enemy_bullet(new_bullet)
	new_bullet.global_position = global_position
	new_bullet.global_rotation = global_rotation
	cooldown_timer = cooldown_time
	return new_bullet





