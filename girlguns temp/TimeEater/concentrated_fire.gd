extends EnemyState

var shot_time : float = 0.3
var burst_count : int = 5

var shot_timer : float = 0
var shots_fired : int = 0

func state_allow()->bool:
	return true

func state_enter():
	shots_fired = 0
	shot_timer = shot_time
	for eye in unit.eyelist:
		eye.player_lock()
	return

func state_exit():
	return

func enemy_ready():
	return

func state_input(input : String):
	return

func state_process(delta : float):

	shot_timer -= delta
	if shot_timer <= 0:
		
		
		var eye = unit.eyelist[shots_fired % unit.eyelist.size()]
		eye.straight_shot(burst_count)
		eye.wide_shot(6,60)
		shots_fired += 1
		shot_timer = shot_time


	if shots_fired >= 24:
		emit_signal("state_change","launch_and_call")
	return
