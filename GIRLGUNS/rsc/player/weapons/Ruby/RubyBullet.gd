extends Bullet

@onready var narrow : Area2D = get_node("Narrow")
@onready var wide : Area2D = get_node("Wide")

var homing_target : Enemy
var turn_speed_degrees = 120
var turn_speed_accel = 40
var speed_accel = 40

func move(delta : float):
	if homing_target != null:
		if homing_target in pierced:
			homing_target = null
	
	if homing_target == null:
		var targets : Array[Area2D] = narrow.get_overlapping_areas()
		check_targets(targets)
		if homing_target == null:
			targets = wide.get_overlapping_areas()
			check_targets(targets)
	
	if homing_target != null:
		turn(delta)
	
	super(delta)

func check_targets(targets):
	for target in targets:
		if target in pierced:
			continue
		if homing_target == null:
			homing_target = target
		else:
			if target.global_position.distance_to(global_position) < homing_target.global_position.distance_to(global_position):
				homing_target = target

func turn(delta : float):
	var angle_diff : float = angle_difference(global_rotation,global_position.angle_to_point(homing_target.global_position))
	turn_speed_degrees += turn_speed_accel * delta
	speed += speed_accel * delta
	if abs(angle_diff) < deg_to_rad(turn_speed_degrees) * delta:
		look_at(homing_target.global_position)
		return
	if angle_diff > 0:
		global_rotation_degrees += turn_speed_degrees * delta
	else:
		global_rotation_degrees -= turn_speed_degrees * delta
