extends EnemyState

func  state_process(delta : float):
	unit.look_at(Globals.player.global_position)
	var direction = Vector2.from_angle(unit.global_position.angle_to_point(Globals.player.global_position))
	unit.set_deferred("global_position",unit.global_position + (direction * unit.speed * delta))
	return
