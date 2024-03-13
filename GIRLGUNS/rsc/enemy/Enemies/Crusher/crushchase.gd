extends EnemyState

@export var charge_target : float = 380

func  state_process(delta : float):
	unit.look_at(Globals.player.global_position)
	if unit.global_position.distance_to(Globals.player.global_position) > 20:
		var direction = Vector2.from_angle(unit.global_position.angle_to_point(Globals.player.global_position))
		unit.global_position += (direction * unit.speed * delta)
	if unit.global_position.distance_to(Globals.player.global_position) <= charge_target:
		emit_signal("state_change","crushcharge")
	return
