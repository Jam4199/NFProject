extends EnemyState


func state_allow()->bool:
	return true

func state_enter():
	for eye in unit.eye_list:
		eye.inner_locked = true
	return

func state_exit():
	for eye in unit.eye_list:
		eye.inner_locked = false
		eye.fade(true)
		eye.weapon.spawn()
	return

func enemy_ready():
	return

func state_input(input : String):
	return

func state_process(delta : float):
	var direction = Vector2.from_angle(unit.global_position.angle_to_point(Vector2(0,0)))
	if unit.global_position.distance_to(Vector2(0,0)) > unit.speed * delta:
		unit.global_position += (direction) * unit.speed * delta
	else:
		unit.global_position = Vector2(0,0)
		emit_signal("state_change","spread_beam")
	return
