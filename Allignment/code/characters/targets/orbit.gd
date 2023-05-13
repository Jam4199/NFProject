extends Enemy

var weapon_count: int = 0

func movement(delta : float):
	
	get_parent().get_parent().progress += 100 * delta
	
	var current_degree = rad_to_deg(position.normalized().angle())
	var new_radian = deg_to_rad(current_degree + (30 * delta))
	var new_position = Vector2(cos(new_radian),sin(new_radian)) * position.distance_to(Vector2(0,0))
	position = new_position
	look_at(owner.player.global_position)
	return

func activate():
	await get_tree().create_timer(2.0,false).timeout
	weapon_cycle()
	return

func weapon_cycle():
	if dead:
		return
		
	fire_weapon(weapon_count)
	await get_tree().create_timer(1.2,false).timeout
	weapon_count += 1
	if weapon_count >= weaponcontrol.weapons.size():
		weapon_count = 0
	weapon_cycle()

func enrage():
	weaponcontrol.weapons[0].bullet_stac += 2
	weaponcontrol.weapons[0].rebuild()
	return
