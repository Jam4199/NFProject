extends Weapon

const RUBYBULLET = preload("res://rsc/player/weapons/Ruby/RubyBullet.tscn")

@onready var spawners : Array[Node2D]

func _ready() -> void:
	spawners = [get_node("FL"),get_node("FR"),get_node("RL"),get_node("RR")]

func shoot()->Bullet:
	for spawner in spawners:
		var new_bullet = create_bullet(RUBYBULLET,spawner.global_position,spawner.global_rotation_degrees)
		new_bullet.global_rotation_degrees += (Globals.rng.randf_range(-spread,spread))
	
	return null
