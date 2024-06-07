extends EnemyState

var turn_speed_degrees : float = 360

var initial_timer : float = 0
var initial_time : float = 1

var shot_delay : float = 0.5
var shot_timer : float = 0


var charge_time : float = 2
var charge_timer : float = 0

var substate : int = 0
enum {INIT,DELAY,FIRING}

var total_shots : int = 5
var shot_fired : int = 0


func state_allow()->bool:
	return true

func state_enter():
	initial_timer = initial_time
	shot_fired = 0
	for eye in unit.eyelist:
		eye.free_rotate = true
	return

func state_exit():
	for eye in unit.eyelist:
		eye.interrupt()
	return


func state_process(delta : float):

	match substate:
		INIT:
			turn(delta)
			initial_timer -= delta
			if initial_timer <= 0:
				shot_timer = shot_delay
				for eye in unit.eyelist:
					eye.free_rotate = false
				allign_eyes()
				substate = DELAY
		DELAY:
			turn(delta)
			shot_timer -= delta
			if shot_timer <= 0:
				if total_shots <= shot_fired:
					exit()
					return
				barrage()
				substate = FIRING
				charge_timer = charge_time + 0.2
		FIRING:
			charge_timer -= delta
			if charge_timer <= 0:
				shot_timer = shot_delay
				substate = DELAY
				shot_fired += 1
				allign_eyes()
	



	return

func turn(delta : float):
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	if abs(angle_diff) < deg_to_rad(turn_speed_degrees) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed_degrees * delta
	else:
		unit.global_rotation_degrees -= turn_speed_degrees * delta

func exit():
	emit_signal("state_change","concentrated_fire")

func allign_eyes():
	match shot_fired % 2:
		0:
			batch_a()
		1:
			batch_b()

func barrage():
	match shot_fired % 2:
		0:
			shot_a()
		1:
			shot_b()

func batch_a():
	for eye in [unit.eye00,unit.eye30,unit.eye60,unit.eye90,unit.eye330,unit.eye300,unit.eye270,unit.eye180]:
		eye.rotate_eye_target(unit,0)
	unit.eye120.rotate_eye_target(unit,-20)
	unit.eye150.rotate_eye_target(unit,-40)
	unit.eye210.rotate_eye_target(unit,20)
	unit.eye240.rotate_eye_target(unit,40)



func batch_b():
	for eye in [unit.eye30,unit.eye90,unit.eye330,unit.eye270,unit.eye120,unit.eye240]:
		eye.rotate_eye_target(unit,0)
	for eye in [unit.eye60,unit.eye150]:
		eye.rotate_eye_target(unit,20)
	for eye in [unit.eye210,unit.eye240]:
		eye.rotate_eye_target(unit,-20)

func shot_a():
	for eye in unit.eyelist:
		if not eye == unit.eye180:
			eye.shoot_beem(charge_time)
		else:
			eye.wide_shot(12,20)

func shot_b():
	for eye in unit.eyelist:
		if eye in [unit.eye30,unit.eye90,unit.eye330,unit.eye270,unit.eye60,unit.eye150,unit.eye210,unit.eye240]:
			eye.shoot_beem(charge_time)
		else:
			eye.wide_shot(6,40)


func turn_to_player(delta : float,turn_speed : float = 360):
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	if abs(angle_diff) < deg_to_rad(turn_speed) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed * delta
	else:
		unit.global_rotation_degrees -= turn_speed * delta
