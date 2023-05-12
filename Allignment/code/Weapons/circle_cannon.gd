extends Weapon

@export var radius : float = 20
@export var points : int = 3
@export_enum("SAME_DIRECTION", "OUTWARD", "INWARD") var point_direction : int = 0


var bullet_spawns : Array = []

func _ready() -> void:
	print(str(self.global_rotation_degrees))
	var arc_angle : float = 360 / float(points)
	var this_angle : float
	var new_point : Node2D
	for point in range(0,points):
		this_angle = deg_to_rad(arc_angle * point)
		new_point = Node2D.new()
		add_child(new_point)
		new_point.position = Vector2(cos(this_angle), sin(this_angle)) * radius
		bullet_spawns.append(new_point)
		
		match point_direction:
			0:
				new_point.global_rotation = global_rotation
			1:
				new_point.rotation = this_angle
			2:
				new_point.rotation = this_angle
				new_point.rotation_degrees += 180

	
	return

func fire_bullet():
	
	for point in bullet_spawns:
		
		for n in range(0,bullet_stack):
			var new_bullet : Bullet = create_bullet(bullet_scene)
			apply_mods(new_bullet)
			new_bullet.global_position = point.global_position
			new_bullet.global_rotation = point.global_rotation
			new_bullet.speed -= (n * stack_speed_gap)
			new_bullet.fire()

func rebuild():
	for point in bullet_spawns:
		point.queue_free()
	bullet_spawns = []
	_ready()
