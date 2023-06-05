extends Node

var PlayerBulletLayer : Node2D
var DangerLayer : Node2D
var static_delta

func _ready() -> void:
	static_delta = Settings.static_delta

func add_player_bullet(new_bullet : Bullet):
	if PlayerBulletLayer == null:
		print("no player bullet layer")
		return
	PlayerBulletLayer.add_child(new_bullet)
	new_bullet.add_to_group("World_Bullets")

func add_enemy_bullet(new_bullet : Bullet):
	DangerLayer.add_child(new_bullet)
	new_bullet.add_to_group("World_Bullets")
	

func _physics_process(delta: float) -> void:
	for bullet in get_tree().get_nodes_in_group("World_Bullets"):
		if bullet.queue_despawn == true:
			despawn_bullet(bullet)
			continue
		if bullet.fired == true:
			move_bullet(bullet)
	return

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
	bullet.global_position += bullet.velocity


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
	

