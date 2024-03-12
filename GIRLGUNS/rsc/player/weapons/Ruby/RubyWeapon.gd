extends Weapon
class_name RubyWeapon
const RUBYBULLET = preload("res://rsc/player/weapons/Ruby/RubyBullet.tscn")

@onready var spawners : Array[Node2D]
@onready var circles : Array[Sprite2D] = [get_node("FL/circle0"),get_node("FR/circle1"),get_node("RL/circle2"),get_node("RR/circle3")]

func _physics_process(delta: float) -> void:
	super(delta)
	for circle in circles:
		circle.rotation_degrees += 360 * delta
	
	if ammo > 0:
		modulate = Color(255,0,0)
	else:
		modulate = Color(1,1,1)



func _ready() -> void:
	spawners = [get_node("FL"),get_node("FR"),get_node("RL"),get_node("RR")]

func shoot()->Bullet:
	for spawner in spawners:
		var new_bullet = create_bullet(RUBYBULLET,spawner.global_position,spawner.global_rotation_degrees)
		new_bullet.global_rotation_degrees += (Globals.rng.randf_range(-spread,spread))
	
	return null
