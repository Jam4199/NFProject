extends EnemyState

var moving : bool = false

var max_turn_angle : float = 2
var move_time : float = 0.8
var random_angle_mod : float = 10

var move_timer : float = 0



func state_process(delta : float):
	if Globals.player == null:
		return
	if moving:
		move(delta)
	if moving:
		return
	var angle_diff = abs(angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position)))
	if angle_diff > deg_to_rad(max_turn_angle):
		emit_signal("state_change","Curve")
		return
	else:
		move_start()
		move(delta)
	return

func move_start():
	move_timer = 0
	moving = true
	unit.look_at(Globals.player.global_position)
	unit.rotation_degrees += Globals.rng.randf_range(-random_angle_mod,random_angle_mod)

func move(delta : float):
	move_timer += delta
	unit.global_position += Vector2.from_angle(unit.global_rotation) * unit.speed * delta
	if move_timer >= move_time:
		moving = false
		return
	 
