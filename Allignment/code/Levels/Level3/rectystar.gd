extends Enemy


var weapon_count : int = 0

func movement(delta : float):
	
	var pointy : PathFollow2D = get_parent()
	pointy.progress += 100 * delta
	return

func activate():
	await get_tree().create_timer(2.0,false).timeout
	weapon_cycle()
	return

func weapon_cycle():
	if dead:
		return
	look_at(player.global_position)
	fire_weapon(weapon_count)
	rotation = 0
	weapon_count += 1
	if weapon_count > 1:
		weapon_count = 0
	await get_tree().create_timer(1.5,false).timeout
	weapon_cycle()

func enrage():
	for weapon in weaponcontrol.weapons:
		weapon.bullet_stack += 1
