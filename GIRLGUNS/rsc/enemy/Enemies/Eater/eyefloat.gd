extends EnemyState

var floating : bool = false
var float_target : Vector2

func state_enter():
	unit.call_deferred("fade",false)
	floating = false

func state_exit():
	unit.call_deferred("fade",true)

func state_process(delta):
	if unit.inner_locked:
		return
	if Globals.player != null:
		unit.look_at(Globals.player.global_position)
	if floating == false:
		floating = true
		create_float_target()
	else:
		floaty(delta)

func fade(bah : bool):
	unit.monitorable = bah
	unit.monitoring = bah
	

func create_float_target():
	
	if unit.position.length() > 140:
		float_target = unit.position.limit_length(120)
		return
	
	if unit.position == Vector2(0,0):
		float_target = Vector2.from_angle(Globals.rng.randf_range(-PI,PI)) * Globals.rng.randf_range(40,120)
		return
	var distance : float = 120.0 - (unit.position.length()/2) + Globals.rng.randf_range(30,80)
	var angle : float = unit.position.angle_to_point(Vector2(0,0))
	angle = rad_to_deg(angle)
	var angle_rand : float = Globals.rng.randf_range(-60,60)
	distance -= abs(angle_rand)
	angle += angle_rand
	angle = deg_to_rad(angle)
	float_target = (Vector2.from_angle(angle) * distance) + unit.position
	return

func floaty(delta):
	var speed = (unit.speed * delta) / 3
	if unit.position.length() > 120:
		speed *= 2
	if unit.position.distance_to(float_target) < speed:
		unit.position = float_target
		floating = false
	else:
		var velocity : Vector2 = Vector2.from_angle(unit.position.angle_to_point(float_target)) * speed
		unit.position += velocity
