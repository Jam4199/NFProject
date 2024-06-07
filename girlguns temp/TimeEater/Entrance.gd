extends EnemyState


func state_allow()->bool:
	return true

func state_enter():
	unit.look_at(Vector2(0,0))
	return

func state_exit():
	return

func enemy_ready():
	return

func state_input(input : String):
	return

func state_process(delta : float):
	unit.look_at(Vector2(0,0))
	unit.global_position += (Vector2.from_angle(unit.global_rotation) * unit.speed * delta)
	if global_position.length() <= unit.speed * 2 * delta:
		global_position = Vector2(0,0)
		emit_signal("state_change","light_shower")
	return
