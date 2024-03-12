extends Weapon
class_name AsterWeapon
const ASTERBULLET = preload("res://rsc/player/weapons/Aster/AsterBullet.tscn")

@onready var spawns : Array[Node2D] = [get_node("A"),get_node("B")]
@onready var circles : Array[Sprite2D] = [get_node("%CircleA"),get_node("%CircleB")]
var current_spawn : bool = false

func _physics_process(delta: float) -> void:
	super(delta)
	if ammo > 0:
		for circle in circles:
			circle.rotation_degrees += 360 * delta
			circle.modulate = Color(1,1,1)
	else:
		for circle in circles:
			circle.rotation_degrees += 360 * delta
			circle.modulate = Color(10,10,10)
	

func shoot()->Bullet:
	var spawn_position : Vector2 = spawns[int(current_spawn)].global_position
	var new_bullet = create_bullet(ASTERBULLET,spawn_position,global_rotation_degrees)
	new_bullet.global_rotation_degrees += (Globals.rng.randf_range(-spread,spread))
	current_spawn = not current_spawn
	return new_bullet
