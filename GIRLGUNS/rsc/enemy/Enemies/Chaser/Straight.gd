extends EnemyState

var moving : bool = false

var max_turn_angle : float = 2
var move_time : float = 1

var move_timer : float = 0



func state_process(delta : float):
	if Globals.player == null:
		return
	if moving:
		move(delta)
		return
	var angle_diff = abs(angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position)))
	if angle_diff > deg_to_rad(max_turn_angle):
		emit_signal("state_change","Curve")
		return
	else:
		move_start()
	return

func move_start():
	move_timer = 0
	moving = true
	unit.look_at(Globals.player.global_position)
	unit.rotation_degrees += Globals.rng.randf_range(-1,1)

func move(delta : float):
	move_timer += delta
	if move_timer >= move_time:
		moving = false
		return
	unit.global_position += Vector2.from_angle(unit.global_rotation) * unit.speed * delta
	 
