extends Node

var static_delta

func _ready() -> void:
	static_delta = Globals.static_delta

func add_player_bullet(new_bullet : Bullet):
	if Globals.PlayerBulletLayer == null:
		print("no player bullet layer")
		despawn_bullet(new_bullet)
		return
	new_bullet.set_collision_layer_value(2,true)
	Globals.PlayerBulletLayer.add_child(new_bullet)
	new_bullet.add_to_group("World_Bullets")


func add_enemy_bullet(new_bullet : Bullet):
	if Globals.EnemyBulletLayer == null:
		print("not enemy bullet layer")
		despawn_bullet(new_bullet)
		return
	new_bullet.set_collision_layer_value(3,true)
	Globals.EnemyBulletLayer.add_child(new_bullet)
	new_bullet.add_to_group("World_Bullets")


func _physics_process(delta: float) -> void:
	for bullet in get_tree().get_nodes_in_group("World_Bullets"):
		if bullet.queue_despawn == true:
			despawn_bullet(bullet)
			continue
		if bullet.fired == true:
			bullet.lifetime += Globals.static_delta
			move_bullet(bullet)
		else:
			bullet.lifespan += Globals.static_delta
		check_limit(bullet)
	return

func check_limit(bullet : Bullet):
	if (bullet.lifetime > bullet.lifespan
		or bullet.lifespan > Globals.bullet_max_life
		or bullet.total_travel > Globals.bullet_max_travel
		or bullet.total_travel > bullet.max_travel
		):
		bullet.despawn()
	

func despawn_bullet(bullet : Bullet):
	bullet.queue_free()

func move_bullet(bullet : Bullet):
	
	
	if bullet.curve_deg > 0 and bullet.current_curve >= bullet.curvecap:
		bullet.global_rotation_degrees += (bullet.curve_deg * static_delta)
		bullet.current_curve += abs(bullet.curve_deg * static_delta)

	if bullet.accel != 0:
		var new_velocity = bullet.velocity + (bullet.accel * static_delta * rot_to_vec(bullet.global_rotation))
		if new_velocity.length() > bullet.accel_cap:
			new_velocity = accel_limit(bullet, new_velocity)
		bullet.velocity = new_velocity
	
	var final_velocity = bullet.velocity
	var speed_mods : Array = []
	bullet.emit_signal("speed_mod_requested", speed_mods)
	for mod in speed_mods:
		if mod is float:
			final_velocity *= mod
	
	
	bullet.total_travel += (final_velocity.length() * Globals.static_delta)
	bullet.global_position += final_velocity * Globals.static_delta
	bullet.emit_signal("bullet_moved")

func rot_to_vec(angle : float) -> Vector2:
	return Vector2(cos(angle),sin(angle))


func accel_limit(bullet : Bullet ,new_velocity : Vector2) -> Vector2:
	if bullet.new_velocity.length() > bullet.velocity.length():

		if bullet.accel_cap > bullet.velocity.length():
			#move and cap
			return new_velocity.normalized() * bullet.accel_cap

		else:
			#move and dont cap
			return new_velocity.normalized() * bullet.velocity.length()

	else:
		#slow
		return new_velocity


