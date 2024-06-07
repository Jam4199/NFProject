extends EnemyState


var phase_time : float = 8
var initial_delay : float = 1
var total_shots : int =  5
var shot_delay : float = 1
var spread : float = 40

var phase_timer : float = 0
var shot_timer : float = 0
var eye_locked : bool = false

func state_allow()->bool:
	return true

func state_enter():
	shot_timer = initial_delay
	phase_timer = phase_time
	eye_locked = false
	for eye in unit.eyelist:
		eye.free_rotate = true
	return

func state_exit():
	for eye in unit.eyelist:
		eye.interrupt
	return

func enemy_ready():
	return

func state_input(input : String):
	return

func state_process(delta : float):
	phase_timer -= delta
	shot_timer -= delta
	
	if shot_timer <= 1.5 and not eye_locked:
		eye_locked = true
		for eye in unit.eyelist:
			eye.free_rotate = false
			var new_rotate : float = get_angle_to(unit.global_position)
			new_rotate = rad_to_deg(new_rotate)
			if new_rotate > 180:
				new_rotate = 360 - new_rotate
			eye.rotate_eye_degrees(new_rotate)
			
			
	if shot_timer <= 0:
		for eye in unit.eyelist:
			eye.wide_shot(total_shots,spread)
		shot_timer = shot_delay
	
	if phase_timer <= 0:
		emit_signal("state_change","forward_beem")
	return


func turn_to_player(delta : float,turn_speed : float = 360):
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	if abs(angle_diff) < deg_to_rad(turn_speed) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed * delta
	else:
		unit.global_rotation_degrees -= turn_speed * delta
