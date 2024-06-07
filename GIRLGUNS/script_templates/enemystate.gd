
var phase_time : float = 8
var phase_timer : float = 0


func state_allow()->bool:
	return true

func state_enter():
	phase_timer = phase_time
	return

func state_exit():
	return

func enemy_ready():
	return

func state_input(input : String):
	return

func state_process(delta : float):
	phase_timer -= delta
	if phase_timer <= 0:
		emit_signal("state_changed","")
	return
