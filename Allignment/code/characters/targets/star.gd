extends Enemy

var wait_time : float = 2.5
func movement(delta : float):
	
	var pointy : PathFollow2D = get_parent()
	pointy.progress_ratio += 0.125 * delta

func activate():
	await get_tree().create_timer(2.3,false).timeout
	weapon_cycle()

var weapon_count : int = 0

var rng = RandomNumberGenerator.new()

func weapon_cycle():
	if dead:
		return
	weaponcontrol.look_at(owner.player.global_position)
	weaponcontrol.rotation_degrees += rng.randf_range(-5,+5)
	fire_weapon(weapon_count)
	await get_tree().create_timer(wait_time,false).timeout
	weapon_count += 1
	if weapon_count >= weaponcontrol.weapons.size():
		weapon_count = 0
	weapon_cycle()

func enrage():
	wait_time = 1.5
