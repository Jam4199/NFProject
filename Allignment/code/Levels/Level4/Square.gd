extends Enemy

var weapon_count : int = 0
var speedmult = 1

func movement(delta : float):
	
	var pointy : PathFollow2D = get_parent()
	pointy.progress += 100 * (1/speedmult) * delta
	return

func activate():
	await get_tree().create_timer(2.0,false).timeout
	weapon_cycle()
	return

func weapon_cycle():
	if dead:
		return
		
	fire_weapon(weapon_count)
	await get_tree().create_timer(2.2 * speedmult ,false).timeout
	weapon_count += 1
	if weapon_count >= weaponcontrol.weapons.size():
		weapon_count = 0
	weapon_cycle()

func enrage():
	speedmult = 0.7
	return
