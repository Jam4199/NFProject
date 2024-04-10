extends EnemyState

enum {MOVING,WARPING}

const WARNING = preload("res://rsc/enemy/Enemies/Chaser/ChaserR_warning.tscn")

@onready var charging : CPUParticles2D = get_node("charging")

var state : int = 0

var turn_speed_degrees : float = 1440
var target_angle_degrees : float = 0.1

var move_time : float = 6
var move_timer : float = 0

var warp_time : float = 1
var warp_timer : float = 0
var warp_max_radius : float = 20

var warp_location := Vector2(0,0)

func state_process(delta : float):
	if Globals.player == null:
		return
	timers(delta)
	match state:
		MOVING:
			move(delta)
		WARPING:
			if warp_timer >= warp_time:
				warp_finish()
	
	return

func move_start():
	move_timer = 0
	state = MOVING


func move(delta : float):
	move_timer += delta
	unit.global_position += Vector2.from_angle(unit.global_rotation) * unit.speed * delta
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	turn(delta,angle_diff)
	if move_timer >= move_time:
		warp_start()
		return
	 

func turn(delta: float, angle_diff):
	if abs(angle_diff) < deg_to_rad(turn_speed_degrees) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed_degrees * delta
	else:
		unit.global_rotation_degrees -= turn_speed_degrees * delta

func timers(delta : float):
	move_timer += delta
	warp_timer += delta
	return

func warp_start():

	warp_timer = 0
	state = WARPING
	warp_location = Globals.player.global_position
	warp_location += (Globals.player.velocity)
	warp_location += Vector2.from_angle(Globals.rng.randf_range(0,2 * PI)) * Globals.rng.randf_range(0,Globals.rng.randf_range(0,warp_max_radius))

	var new_warning = Globals.add_effect(WARNING.instantiate())
	new_warning.global_position = warp_location
	charging.emitting = true
	
	
	return

func warp_finish():

	move_timer = 0
	state = MOVING
	unit.global_position = warp_location
	unit.look_at(Globals.player.global_position)
	charging.emitting = false
	
	var distancing : float = unit.global_position.distance_to(Globals.player.global_position)
	if distancing >= unit.speed:
		distancing -= unit.speed
		move_timer += move_timer * (distancing / (unit.speed * 2))
	return
