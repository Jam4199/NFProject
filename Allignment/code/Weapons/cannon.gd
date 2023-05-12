extends Weapon

func fire_bullet():
	for n in range(0,bullet_stack):
		var new_bullet : Bullet = create_bullet(bullet_scene)
		apply_mods(new_bullet)
		new_bullet.global_position = global_position
		new_bullet.global_rotation = global_rotation
		new_bullet.speed -= (n * stack_speed_gap)
		new_bullet.fire()
