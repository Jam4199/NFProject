extends Weapon

@export var circle_radius : float = 50
@export var origin_distance : float = 2
@export var bullet_count : int = 3
@export var arc_gap_degrees : float = 10
@export_enum("FORWARD", "ARC", "SPREAD") var point_direction : int = 0

var bullet_spawns : Array = []

func _ready() -> void:
	
	var total_angle = arc_gap_degrees * (bullet_count - 1) 
	var start_angle = -total_angle / 2
	
	var new_point : Node2D
	var arc_rad : float
	for point in range(0,bullet_count):
		arc_rad = deg_to_rad(start_angle + (arc_gap_degrees * (point)))
		new_point = Node2D.new()
		add_child(new_point)
		bullet_spawns.append(new_point)
		new_point.position = (Vector2(cos(arc_rad),sin(arc_rad))) * circle_radius
		new_point.position.x -= circle_radius
		new_point.position.x += origin_distance
		
		match point_direction:
			1:
				new_point.rotation = arc_rad
			2:
				new_point.look_at(self.global_position)
				new_point.global_rotation_degrees += 180

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

