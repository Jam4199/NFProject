extends Weapon

@export var cannons : int = 1
@export var cannon_gap : float = 5
@export var distance : int = 0

var bullet_spawns : Array

func _ready() -> void:
	var total_gap : float = cannon_gap * (cannons -1)
	var starting_gap = -total_gap /2
	
	var new_point : Node2D
	
	for x in range(0,cannons):
		
		new_point = Node2D.new()
		add_child(new_point)
		bullet_spawns.append(new_point)
		new_point.position.x = distance
		new_point.position.y = starting_gap + (cannon_gap * (x))
		


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
