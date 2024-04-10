extends Weapon
class_name ViolaWeapon
const VIOLABULLET = preload("res://rsc/player/weapons/Viola/ViolaBullet.tscn")

@onready var center : Node2D = get_node("Center")
@onready var circle : Sprite2D = get_node("Circle")

func _physics_process(delta: float) -> void:
	super(delta)
	circle.rotation_degrees += 360 * delta
	if ammo > 0:
		circle.modulate = Color(1,1,1)
	else:
		circle.modulate = Color(10,10,10)


func shoot()->Bullet:
	var new_bullet = create_bullet(VIOLABULLET,center.global_position,global_rotation_degrees)
	var max_radius : float = 40 * (spread/180)
	var offset : Vector2 = Vector2.from_angle(Globals.rng.randf_range(0,2 * PI)) * Globals.rng.randf_range(0, max_radius)
	new_bullet.global_position += offset
	return new_bullet


func blessing(source : int):
	match source:
		Weapon.bless.ASTER:
			magazine_adds += 6
			reload_speed_multiplier += 0.2
			return
		Weapon.bless.LYRIS:
			damage_multiplier += 1.2

			return
		Weapon.bless.OPHELIA:
			damage_multiplier += 1
			kb_add += 30
			spread_add_degrees += 10
			return
		Weapon.bless.RUBY:
			aoe_override += 1
			aoe_add += 40
			damage_multiplier += 1
			return
		Weapon.bless.VIOLA:

			return
	return
