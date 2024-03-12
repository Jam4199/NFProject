extends Weapon
class_name ViolaWeapon
const VIOLABULLET = preload("res://rsc/player/weapons/Viola/ViolaBullet.tscn")

@onready var center : Node2D = get_node("Center")

func shoot()->Bullet:
	var new_bullet = create_bullet(VIOLABULLET,center.global_position,global_rotation_degrees)
	var max_radius : float = 40 * (spread/180)
	var offset : Vector2 = Vector2.from_angle(Globals.rng.randf_range(0,2 * PI)) * Globals.rng.randf_range(0, max_radius)
	new_bullet.global_position += offset
	return new_bullet
