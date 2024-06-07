extends EnemyBullet

var max_speed : float = 500
var min_speed : float = 100
var accel : float = 0

var curve : int = 0 
var max_curve : float = 90
var curve_rate : float = 30

func move(delta : float):
	
	if speed != 0 and max_curve > 0:
		var new_curve : float = curve_rate * delta
		if new_curve > max_curve:
			new_curve = max_curve
		max_curve -= new_curve
		if curve < 0:
			new_curve *= -1
	
	speed += (accel * delta)
	if speed > max_speed:
		speed = max_speed
	if speed < min_speed:
		speed = min_speed
	
	global_position += (Vector2.from_angle(global_rotation) * (speed * delta))
	total_distance += speed * delta
	
	if abs(global_position.x) > 1300 or abs(global_position.y) > 700:
		bullet_end()
	
	if total_distance >= max_distance or total_time >= lifetime:
		bullet_end()
		return

	return
