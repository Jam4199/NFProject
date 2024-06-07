extends EnemyState

var charge_time : float = 3
var timer : float = 0

var allowance : float = 0.8

func state_input(input : String):
	match input:
		"interrupt":
			emit_signal("state_change","mouth_idle")
	return

func state_enter():
	unit.wep.rotation = 0
	unit.wep.shoot_beem(charge_time)
	timer = charge_time

func state_end():
	unit.wep.interrupt()

func state_process(delta):
	timer -= delta
	if timer > allowance:
		turn_to_player(delta)
	
	if timer <= 0 and unit.wep.charge_timer <= 0:
		emit_signal("state_change","mouth_idle")


func turn_to_player(delta : float,turn_speed : float = 720):
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	if abs(angle_diff) < deg_to_rad(turn_speed) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed * delta
	else:
		unit.global_rotation_degrees -= turn_speed * delta
