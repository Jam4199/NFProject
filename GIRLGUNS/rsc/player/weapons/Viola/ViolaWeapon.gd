extends Weapon
const VIOLABULLET = preload("res://rsc/player/weapons/Viola/ViolaBullet.tscn")


func shoot()->Bullet:
	var new_bullet = create_bullet(VIOLABULLET,global_position,rotation_degrees)
	new_bullet.rotation_degrees += (Globals.rng.randf_range(-spread,spread))
	return new_bullet
