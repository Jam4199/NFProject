extends Weapon
const LYRISBULLET = preload("res://rsc/player/weapons/Lyris/LyrisBullet.tscn")

@onready var spawnpoint : Node2D = get_node("Spawn")

func shoot()->Bullet:
	var new_bullet = create_bullet(LYRISBULLET,spawnpoint.global_position,global_rotation_degrees)
	new_bullet.global_rotation_degrees += (Globals.rng.randf_range(-spread,spread))
	return new_bullet
