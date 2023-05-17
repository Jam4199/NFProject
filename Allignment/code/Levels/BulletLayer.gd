extends Node2D
class_name BulletLayer

func bullet_made(new_bullet : Bullet):
	add_child(new_bullet)
	new_bullet.add_to_group("bullets")


func _physics_process(delta: float) -> void:
	for bullet in get_tree().get_nodes_in_group("bullets"):
		if bullet.fired == false:
			continue
		if bullet.queue_despawn:
			despawn(bullet)
			continue
		bullet.global_rotation_degrees += (bullet.curve * delta)
		
		bullet.global_position += (Vector2(cos(bullet.global_rotation),sin(bullet.global_rotation)) * bullet.speed * delta)
		
		
		var new_speed = bullet.speed + (bullet.acceleration * delta)
		if new_speed < bullet.min_speed:
			new_speed = bullet.min_speed
		
		if new_speed > bullet.max_speed:
			new_speed = bullet.max_speed
		bullet.speed = new_speed
		
		
		if bullet.spin: #fuck my life
			match bullet.spin_type:
				0: 
					spin_degrees(bullet,delta)
				1:
					spin_length(bullet,delta)


func spin_degrees(bullet : Bullet, delta : float):
	if bullet.spin_rising > bullet.spin_cap:
		return
	var distance = bullet.origin.distance_to(bullet.global_position)
	var start_angle = rad_to_deg(bullet.origin.angle_to(bullet.global_position))
	var new_angle = deg_to_rad((bullet.spin_speed * delta) + start_angle)
	bullet.global_position = bullet.origin + (Vector2(cos(new_angle),sin(new_angle)) * distance)
	bullet.spin_rising += (abs(bullet.spin_speed) * delta)

func spin_length(bullet : Bullet, delta : float):
	var radius = bullet.origin.distance_to(bullet.global_position)
	var current_radian = bullet.origin.angle_to(bullet.global_position)
	var new_radian = ((bullet.spin_speed *delta) / radius) + current_radian
	bullet.global_position = bullet.origin + (Vector2(cos(new_radian),sin(new_radian)) * radius)

func despawn(bullet : Bullet):
	owner.create_particle(owner.BulletDeathParticle,bullet.global_position)
	bullet.queue_free()
