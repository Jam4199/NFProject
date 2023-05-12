extends Enemy

var weapon_count : int = 0

func movement(delta : float):
	self.look_at(owner.global_position)
	var pointy : PathFollow2D = get_parent()
	pointy.progress += 100 * delta
	
	

func activate():
	await get_tree().create_timer(2,false).timeout
	weapon_cycle()

func weapon_cycle():
	if dead:
		return
	fire_weapon(weapon_count)
	await get_tree().create_timer(1.5,false).timeout
	weapon_count += 1
	if weapon_count >= weaponcontrol.weapons.size():
		weapon_count = 0
	weapon_cycle()

func enrage():
	for weapon in weaponcontrol.weapons:
		weapon.bullet_stack += 2
	
	weaponcontrol.weapons[1].bullet_count += 4
	weaponcontrol.weapons[1].rebuild()
