extends EnemyState

var sides : Array[TSubWep]

var current_offset : float = 0

var initial_delay : float = 1
var initial_timer : float = 0

var shot_count : int = 4
var burst_count : int = 6
var burst_spread : float = 40
var burst_cd : float = 4
var shot_cd : float = 0.2

var sweep_direction : float = 1
var shot_counter : int = 0
var burst_counter : int = 0
var burst_timer : float = 0
var shot_timer : float = 0

var current_state : int = 0
enum {INITIAL,SHOOTING,RESTING}

func state_enter():
	initial_timer = initial_delay
	current_state = INITIAL
	for eye in unit.eyelist:
		eye.free_rotate = false
		eye.rotate_eye_degrees(eye.rotation_degrees * -1)

func state_process(delta : float):
	match current_state:
		INITIAL:
			initial_timer -= delta
			turn_to_player(delta)
			if initial_timer <= 0:
				current_state = SHOOTING
				shot_timer = shot_cd
				sweep_direction = -1
				shot_counter = 0
				burst_counter = 0
				for eye in unit.eyelist:
					eye.rotation_degrees = burst_spread / 2
		
		SHOOTING:
			shot_timer -= delta
			if shot_timer <= 0:
				shot_timer = shot_cd
				for eye in unit.eyelist:
					eye.rotation_degrees += (sweep_direction * (burst_spread / float(burst_count)))
					eye.straight_shot(3,0,200,400)
				shot_counter += 1
			
			if shot_counter >= shot_count:
				burst_timer = burst_cd
				sweep_direction *= -1
				burst_counter  += 1
				current_state = RESTING
		
			if burst_counter >= burst_count:
				emit_signal("state_change","return_and_beem")
		
		RESTING:
			turn_to_player(delta)
			burst_timer -= delta
			if burst_timer <= 0:
				shot_counter = 0
				current_state = SHOOTING
			





func turn_to_player(delta : float,turn_speed : float = 360):
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	if abs(angle_diff) < deg_to_rad(turn_speed) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed * delta
	else:
		unit.global_rotation_degrees -= turn_speed * delta









