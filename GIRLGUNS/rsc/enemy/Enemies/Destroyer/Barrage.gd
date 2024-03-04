extends EnemyState

var turn_speed_degrees : float = 270

var spread_degrees : float = 80
var cooldown_mod_rng : float = 0.4
var barrage_wait : float = 2
var barrage_bullet_slowdown = 150
var phase_time : float = 6
var enraged : bool = false

var subweps : Array[EnemyWeapon] = []
var mainwep : EnemyWeapon
var spreadwep : EnemyWeapon
var anim : AnimationPlayer
var phase_timer : float = 0



func enemy_ready():
	var wepname : String = "SubWep"
	for n in range(0,9):
		subweps.append(get_node("%" + wepname + str(n)))
	mainwep = get_node("%MainWep")
	anim = get_node("%SpriteAnim")
	spreadwep = get_node("%SpreadWep")

func state_enter():
	phase_timer = phase_time
	for subwep in subweps:
		subwep.cooldown_timer = 0
	return


func state_process(delta : float):
	phase_timer -= delta
	
	
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	turn(delta,angle_diff)
	
	
	if phase_timer < phase_time - barrage_wait:
		barrage()
	
	if phase_timer <= 0:
		emit_signal("state_change","BEEM")
	
	return

func turn(delta : float, angle_diff : float):
	if abs(angle_diff) < deg_to_rad(turn_speed_degrees) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed_degrees * delta
	else:
		unit.global_rotation_degrees -= turn_speed_degrees * delta



func barrage():
	for subwep in subweps:
		if subwep.cooldown_timer <= 0:
			subwep.look_at(Globals.player.global_position)
			subwep.global_rotation_degrees += Globals.rng.randf_range(-spread_degrees,spread_degrees)
			var new_bullet = subwep.shoot()
			new_bullet.speed -= barrage_bullet_slowdown
			subwep.cooldown_timer = Globals.rng.randf_range(0,cooldown_mod_rng)
	if spreadwep.cooldown_timer <= 0 and enraged:
		spreadwep.shoot()
		spreadwep.cooldown_timer = Globals.rng.randf_range(0,cooldown_mod_rng)

func enrage():
	enraged = true


