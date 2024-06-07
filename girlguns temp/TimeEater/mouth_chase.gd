extends EnemyState


var dist_weight : float = 2

func state_allow()->bool:
	return true

func state_enter():
	return

func state_exit():
	return

func enemy_ready():
	return

func state_input(input : String):
	match input:
		"interrupt":
			emit_signal("state_change","mouth_idle")
	return

func state_process(delta : float):
	if unit.partner.alive and (partner_distance() < unit.global_position.distance_to(Globals.player.global_position)):
		var direction = ((player_direction() * dist_weight) + partner_direction()) / (1.0 + dist_weight)
		global_rotation = direction.angle()
	else:
		turn_to_player(delta)
	
	var velocity : Vector2 = Vector2.from_angle(unit.global_rotation) * unit.speed * delta
	unit.global_position += velocity
	
	return

func partner_distance() -> float:
	return unit.global_position.distance_to(unit.partner.global_position)

func partner_direction() -> Vector2:
	return Vector2.from_angle(unit.global_position.angle_to_point(unit.partner.global_position))
	

func player_direction() -> Vector2:
	return Vector2.from_angle(unit.global_position.angle_to_point(Globals.player.global_position))
	
	


func turn_to_player(delta : float,turn_speed : float = 720):
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	if abs(angle_diff) < deg_to_rad(turn_speed) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed * delta
	else:
		unit.global_rotation_degrees -= turn_speed * delta

