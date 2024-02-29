extends EnemyState

var turn_speed_degrees : float = 270
var target_angle_degrees : float = 0.1
var move_speed_mult : float = 1

func state_process(delta : float):
	if Globals.player == null:
		return
	
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	move(delta)
	turn(delta,angle_diff)
	if abs(angle_diff) < deg_to_rad(target_angle_degrees) :
		emit_signal("state_change","Straight")
		return
	return

func turn(delta : float, angle_diff : float):
	if abs(angle_diff) < deg_to_rad(turn_speed_degrees) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed_degrees * delta
	else:
		unit.global_rotation_degrees -= turn_speed_degrees * delta
	

func move(delta : float):
	unit.global_position += Vector2.from_angle(unit.global_rotation) * unit.speed * delta * move_speed_mult

