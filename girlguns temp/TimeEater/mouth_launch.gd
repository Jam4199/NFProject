extends EnemyState

@onready var warning : AttackWarning = get_node("AttackWarning")

var charge_time : float = 2
var launch_time : float = 1
var launch_allowance : float = 0.8

var substate : int = 0
enum {CHARGING,LAUNCHING}

var launch_range : float = 2000

var timer : float = 0



func state_allow()->bool:
	return true

func state_enter():
	substate = CHARGING
	timer = charge_time
	return

func state_exit():
	warning.end()
	return

func enemy_ready():
	return

func state_input(input : String):
	match input:
		"interrupt":
			emit_signal("state_change","mouth_idle")
	return

func state_process(delta : float):
	timer -= delta
	match substate:
		CHARGING:
			if timer > launch_allowance:
				turn_to_player(delta)
				warning.start()
			
			if timer <= 0:
				timer = launch_time
				substate = LAUNCHING
		
		LAUNCHING:
			var speed : float = (launch_range / launch_time) * delta
			var velocity : Vector2 = Vector2.from_angle(unit.global_rotation) * speed
			unit.global_position += velocity
			
			if timer <= delta:
				emit_signal("state_change","mouth_chase")
	return


func turn_to_player(delta : float,turn_speed : float = 720):
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	if abs(angle_diff) < deg_to_rad(turn_speed) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed * delta
	else:
		unit.global_rotation_degrees -= turn_speed * delta

