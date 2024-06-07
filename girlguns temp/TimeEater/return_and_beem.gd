extends EnemyState

var initial_time : float = 3
var delay_time : float = 1
var charge_time : float = 3
var charge_opening : float = 0.5
var end_time : float = 0

var timer : float = 0

var substate : int = 0

enum {INITIAL,DELAY,CHARGING,END}

func state_enter():
	substate = INITIAL
	for eye in unit.eyelist:
		eye.free_rotate = true
	timer = initial_time

func state_exit():
	for eye in unit.eyelist:
		eye.interrupt()
	for mouth in unit.mouths:
		mouth.state_input("interrupt")

func state_process(delta):
	timer -= delta
	match substate:
		INITIAL:
			turn_to_player(delta)
			if timer <= 0:
				timer = delay_time
				substate = DELAY
				for mouth in unit.mouths:
					mouth.attach()
				for eye in unit.eyelist:
					eye.free_rotate = false
					eye.rotate_eye_target(unit,0)
		DELAY:
			turn_to_player(delta)
			if timer <= 0:
				for mouth in unit.mouths:
					mouth.change_state("mouth_beem")
				for eye in unit.eyelist:
					eye.shoot_beem(charge_time)
				timer = charge_time
				substate = CHARGING
		CHARGING:
			if timer > charge_opening:
				turn_to_player(delta)
			if timer <= 0:
				timer = end_time
				substate = END
		END:
			if timer <= 0:
				emit_signal("state_change","light_shower")


func turn_to_player(delta : float,turn_speed : float = 360):
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	if abs(angle_diff) < deg_to_rad(turn_speed) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed * delta
	else:
		unit.global_rotation_degrees -= turn_speed * delta


