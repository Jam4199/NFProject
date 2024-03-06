extends EnemyState

var turn_speed_degrees : float = 120
var subwep_cd_range : float = 1
var bullet_spread : float = 10
var phase_time : float = 8 #8
var phase_timer : float = 0
var speed_mod : float = 1

var enrage_phase_time : float = 8
var enrage_speed_multiplier : float = 2.5
var enraged : bool = false

enum {FORWARD,SPREAD,FOCUS}
var current_pattern : int

var subweps : Array[EnemyWeapon] = []
var mainwep : EnemyWeapon
var anim : AnimationPlayer

func enemy_ready():
	var wepname : String = "SubWep"
	for n in range(0,9):
		subweps.append(get_node("%" + wepname + str(n)))
	mainwep = get_node("%MainWep")
	anim = get_node("%SpriteAnim")

func state_enter():
	for subwep in subweps:
		subwep.cooldown_timer = subwep.cooldown_time
	current_pattern = 0
	phase_timer = phase_time
	if anim.current_animation != "base":
		anim.play("base")


func state_process(delta : float):
	phase_timer -= delta
	
	var shot_fired : bool = false
	for subwep in subweps:
		if enraged:
			break
		if subwep.cooldown_timer <= 0:
			shot_fired = true
			var base_direction = 0
			if enraged:
				base_direction = global_position.angle_to_point(Globals.player.global_position)
			match current_pattern:
				FORWARD:
					subwep.global_rotation = base_direction
					
				SPREAD:
					subwep.global_rotation_degrees = rad_to_deg(base_direction) + Globals.rng.randf_range(-20,20)
				FOCUS:
					subwep.look_at(Globals.player.global_position)
			var new_bullet : EnemyBullet = subwep.shoot()
			if enraged:
				new_bullet.speed += 300
				new_bullet.min_speed = 200

		
	if shot_fired:
		current_pattern += 1
		if current_pattern > 2:
			current_pattern = 0
	
	var angle_diff = angle_difference(unit.global_rotation,unit.global_position.angle_to_point(Globals.player.global_position))
	turn(delta,angle_diff)
	
	if unit.global_position.distance_to(Globals.player.global_position) > 20:
		var direction = Vector2.from_angle(unit.global_rotation)
		
		unit.global_position += (direction * unit.speed * delta * speed_mod)
	
	if phase_timer <= 0:
		emit_signal("state_change","Barrage")


func turn(delta : float, angle_diff : float):
	if abs(angle_diff) < deg_to_rad(turn_speed_degrees) * delta:
		unit.look_at(Globals.player.global_position)
		return
	if angle_diff > 0:
		unit.global_rotation_degrees += turn_speed_degrees * delta
	else:
		unit.global_rotation_degrees -= turn_speed_degrees * delta


func enrage():
	enraged = true
	phase_time = enrage_phase_time
	speed_mod = enrage_speed_multiplier

