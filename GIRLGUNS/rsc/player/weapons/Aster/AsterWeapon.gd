extends Weapon
const ASTERBULLET = preload("res://rsc/player/weapons/Aster/AsterBullet.tscn")

@onready var spawns : Array[Node2D] = [get_node("A"),get_node("B")]
var current_spawn : bool = false

func shoot()->Bullet:
	var spawn_position : Vector2 = spawns[int(current_spawn)].global_position
	var new_bullet = create_bullet(ASTERBULLET,spawn_position,rotation_degrees)
	new_bullet.rotation_degrees += (Globals.rng.randf_range(-spread,spread))
	current_spawn = not current_spawn
	return new_bullet
