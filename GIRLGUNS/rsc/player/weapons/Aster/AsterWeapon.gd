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

func blessing(source : int):
	match source:
		Weapon.bless.ASTER:
			return
		Weapon.bless.LYRIS:
			damage_multiplier += 0.6
			return
		Weapon.bless.OPHELIA:
			kb_add += 30
			damage_multiplier += 0.6
			spread_add_degrees += 20
			return
		Weapon.bless.RUBY:
			aoe_override += 1
			aoe_add += 20
			damage_multiplier += 0.2
			rof_multiplier += 0.2
			magazine_adds += 4
			return
		Weapon.bless.VIOLA:
			pierce_add += 3
			damage_multiplier += 0.1
			rof_multiplier += 0.1
			reload_speed_multiplier += 0.3
			spread_add_degrees += -10
			return
	return
