extends EnemyState

func  state_process(delta : float):
	unit.look_at(Globals.player.global_position)
	if unit.global_position.distance_to(Globals.player.global_position) > 20:
		var direction = Vector2.from_angle(unit.global_position.angle_to_point(Globals.player.global_position))
		unit.set_deferred("global_position",unit.global_position + (direction * unit.speed * delta))
	if unit.global_position.distance_to(Globals.player.global_position) <= 300:
		emit_signal("state_change","Attack")
	return
