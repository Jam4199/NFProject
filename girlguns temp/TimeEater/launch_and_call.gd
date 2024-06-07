extends EnemyState

@export var summons : Array[Progression] = []

var turn_speed_degrees : float = 360

var initial_timer : float = 0
var initial_time : float = 1

var charge_timer : float = 0
var charge_time : float = 2

var delay_timer : float = 0
var delay_time : float = 0.5


var substate : int = 0
enum {INITIAL,CHARGING,DELAYING}

func state_allow()->bool:
	return true

func state_enter():
	for eye in unit.eyelist:
		eye.free_rotate = true
	substate = INITIAL
	initial_timer = initial_time

	return

func state_exit():
	for eye in unit.eyelist:
		eye.interrupt()
	return

func enemy_ready():
	return

func state_input(input : String):
	return

func state_process(delta : float):
	
	match substate:
		INITIAL:
			turn(delta)
			initial_timer -= delta
			if initial_timer <= 0:
				for eye in unit.eyelist:
					eye.free_rotate = false
					eye.shoot_beem(charge_time)
				for mouth in unit.mouths:
					mouth.launch()
				substate = CHARGING
				charge_timer = charge_time
		CHARGING:
			charge_timer -= delta
			if charge_timer <= 0:
				for eye in unit.eyelist:
					eye.wide_shot(5, 72)
				var batch : int = Globals.rng.randi_range(0,summons.size() - 1)
				for index in range(0,summons[batch].enemies.size()):
					for count in range(0,summons[batch].spawn_count[index]):
						var eye_spawn = unit.eyelist.pick_random()
						var new_enemy : Enemy = summons[batch].enemies[index].instantiate()
						Globals.add_enemy(new_enemy)
						Globals.world.runprogress.modify_enemy(new_enemy)
						new_enemy.global_position = eye_spawn.global_position
						new_enemy.global_rotation = eye_spawn.global_rotation
				substate = DELAYING
				delay_timer = delay_time
		DELAYING:
			delay_timer -= delta
			if delay_timer <= 0:
				emit_signal("state_change", "round_sweep")
	return

func turn(delta : float):
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	if abs(angle_diff) < deg_to_rad(turn_speed_degrees) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed_degrees * delta
	else:
		unit.global_rotation_degrees -= turn_speed_degrees * delta
