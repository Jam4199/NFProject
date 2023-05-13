extends Enemy

var weapon_count : int = 0
var rng := RandomNumberGenerator.new()

func movement(delta : float):
	
	var pointy : PathFollow2D = get_parent()
	pointy.progress += 200 * delta
	self.look_at(owner.player.global_position)

func activate():
	await get_tree().create_timer(2,false).timeout
	weapon_cycle()

func weapon_cycle():
	if dead:
		return
	weaponcontrol.rotation = 0
	weaponcontrol.rotation_degrees += rng.randf_range(-5,+5)
	fire_weapon(weapon_count)
	await get_tree().create_timer(1,false).timeout
	weapon_count += 1
	if weapon_count >= weaponcontrol.weapons.size():
		weapon_count = 0
	weapon_cycle()

func enrage():
	weaponcontrol.weapons[0].bullet_stack += 1
	return
