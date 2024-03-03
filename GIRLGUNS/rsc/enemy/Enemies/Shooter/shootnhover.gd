extends EnemyState

var max_distance : float = 500
var min_distance : float = 200

var drift_speed_mod : float = 0.5
var drift_spread : float = 20
var drift_time : float = 2
var drift_time_spread : float = 0.8
var drift_direction : float
var drift_timer : float

var wep : EnemyWeapon

func enemy_ready():
	wep = get_node("%ShooterWep")

func state_enter():
	drift_start()

func drift_start():
	drift_timer = drift_time + Globals.rng.randf_range(-drift_time_spread,drift_time_spread)
	
	var mun : float = 90 + Globals.rng.randf_range(-drift_spread,drift_spread)
	var num :float = Globals.rng.randf_range(0,1)
	
	if num > 0.5:
		drift_direction = deg_to_rad(mun)
	else :
		drift_direction = deg_to_rad(-mun)

func state_process(delta : float):
	drift_timer -= delta
	if drift_timer <= 0:
		drift_start()
	
	
	if wep.cooldown_timer <= 0:
		wep.shoot()
	
	unit.look_at(Globals.player.global_position)
	unit.global_position += Vector2.from_angle(unit.global_rotation + drift_direction) * unit.speed * drift_speed_mod * delta
	
	if global_position.distance_to(Globals.player.global_position) >= max_distance:
		emit_signal("state_change","shootnchase")
	elif global_position.distance_to(Globals.player.global_position) <= min_distance:
		emit_signal("state_change","shootnflee")
	







