extends EnemyState

var turn_speed : float = PI

func state_enter():
	unit.call_deferred("fade",true)


func state_exit():
	unit.call_deferred("fade",true)

func state_process(delta):
	move(delta)
	turn(delta)

func move(delta):
	if unit.inner_locked:
		return
	var speed = unit.speed * delta
	if unit.global_position.distance_to(unit.move_target) < speed:
		unit.global_position = unit.move_target
	else:
		var velocity : Vector2 = Vector2.from_angle(unit.position.angle_to_point(unit.move_target)) * speed
		unit.global_position += velocity

func turn(delta):
	if not unit.angle_targetting:
		return
	var speed : float = turn_speed * delta
	var difference : float = angle_difference(unit.global_rotation, unit.angle_target)
	if difference < 0:
		if difference > -speed:
			unit.global_rotation = unit.angle_target
			unit.angle_targetting = false
		else:
			unit.global_rotation -= speed
	else:
		if difference < speed:
			unit.global_rotation = unit.angle_target
			unit.angle_targetting = false
		else:
			unit.global_rotation += speed
	
