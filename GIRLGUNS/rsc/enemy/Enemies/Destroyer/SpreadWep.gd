extends EnemyWeapon

var radius : float = 20
var shots : int = 12

func shoot(force : bool = false) -> EnemyBullet:
	if cooldown_time <= 0 and force == false:
		return
	var spread : float = 360 / float(shots)
	var current_angle : float = global_rotation
	for n in shots:
		
		var new_bullet : EnemyBullet = bullet_scene.instantiate()
		Globals.add_enemy_bullet(new_bullet)
		new_bullet.global_rotation_degrees = current_angle
		new_bullet.global_position = global_position + (Vector2.from_angle(new_bullet.global_rotation) * radius)
		
		current_angle += spread
	
	
	cooldown_timer = cooldown_time
	return null

