extends EnemyWeapon
class_name TSubWep

const TBEEM = preload("res://rsc/enemy/Enemies/TimeEater/TBEEM.tscn")
const TBALL = preload("res://rsc/enemy/Enemies/TimeEater/Tball.tscn")

@onready var warning : AttackWarning = get_node("Beemwa")

var charge_timer : float = 0
var rotate_target : float = 0
var rotating : bool = false
var rotate_speed : float = 720
var free_rotate : bool = false

var player_locked : bool = false

func player_lock():
	rotating = false
	free_rotate = false
	player_locked = true


func _physics_process(delta: float) -> void:
	
	if player_locked:
		var angle_diff = angle_difference(global_rotation,global_position.angle_to_point(Globals.player.global_position))
		if abs(angle_diff) < deg_to_rad(rotate_speed) * delta:
			look_at(Globals.player.global_position)
		elif angle_diff > 0:
			global_rotation_degrees += rotate_speed * delta
		else:
			global_rotation_degrees -= rotate_speed * delta
	
	if rotating and not charge_timer > 0:
		var new_rotate = rotate_speed * delta
		if abs(rotate_target) < new_rotate:
			global_rotation_degrees += new_rotate
			rotate_target - new_rotate
			rotating = false
		else:
			if rotate_target < 0:
				new_rotate *= - 1
			global_rotation_degrees += new_rotate
			rotate_target -= new_rotate
	#if rotating and not charge_timer > 0:
		#var new_rotate = rotate_speed * delta
		#if abs(rotate_target) < new_rotate:
			#new_rotate = abs(rotate_target)
		#if rotate_target < 0:
			#new_rotate *= -1
		#rotation_degrees -= new_rotate
		#rotate_target -= new_rotate
		#if abs(rotate_target) <= 0:
			#rotating = false
	elif free_rotate and not charge_timer > 0:
		rotate_eye_degrees(Globals.rng.randf_range(-30,30), 180)
	
	
	if charge_timer > 0:
		charge_timer -= delta
		if charge_timer <= 0:
			custom_shoot(TBEEM)

func rotate_eye_degrees(new_target : float, rspeed : float = 720):
	player_locked = false
	rotating = true
	rotate_target = new_target
	rotate_speed = rspeed

func rotate_eye_target(holder : Enemy , target_degrees : float, rspeed : float = 720):
	free_rotate = false
	var true_target : float = holder.global_rotation_degrees + target_degrees
	var difference : float = true_target - global_rotation_degrees
	if difference > 180:
		difference -= 360
	if difference < -180:
		difference += 360
	print("original : " + str(global_rotation_degrees) + " ,target : " + str(target_degrees) + " ,owner : " + str(holder.global_rotation_degrees) + " ,difference : " + str(difference))
	rotate_eye_degrees(difference, rspeed)

func custom_shoot(scene : PackedScene) -> EnemyBullet:
	var new_bullet : EnemyBullet = scene.instantiate()
	Globals.add_enemy_bullet(new_bullet)
	new_bullet.global_position = global_position
	new_bullet.global_rotation = global_rotation
	new_bullet.damage *= bullet_damage_mult
	new_bullet.speed *= bullet_speed_mult
	return new_bullet

func interrupt():
	charge_timer = 0
	rotating = false
	warning.end()

func shoot_beem(timer : float = 1):
	warning.warning_time = timer
	warning.start()
	charge_timer = timer
	return

func straight_shot(shots : int = 3, angle : float = 0, min_speed : float = 100, max_speed : float = 500, deccel = -300) -> Array[EnemyBullet]:
	var bullet_array : Array[EnemyBullet] = []
	for n in range(0,shots):
		var new_bullet = custom_shoot(TBALL)
		new_bullet.min_speed = min_speed
		new_bullet.max_speed = max_speed
		new_bullet.accel = deccel
		new_bullet.global_rotation = global_rotation + angle
		new_bullet.speed = max_speed - ((max_speed - min_speed) * (float(n)/float(shots)) )
		bullet_array.append(new_bullet)
	return bullet_array

func wide_shot(shots : int = 5, spread : float = 20, offset : float = 0) -> Array[EnemyBullet]:
	var bullet_array : Array[EnemyBullet] = []
	var starting_angle :float = (-1 * ((spread * shots) / 2)) + offset
	for n in shots:
		var new_bullet = custom_shoot(TBALL)
		new_bullet.global_rotation_degrees = global_rotation_degrees + starting_angle + (spread * n)
		bullet_array.append(new_bullet)
	return bullet_array
