extends Weapon
class_name LyrisWeapon
const LYRISBULLET = preload("res://rsc/player/weapons/Lyris/LyrisBullet.tscn")

@onready var spawnpoint : Node2D = get_node("Spawn")
@onready var circle : Sprite2D = get_node("Circle")
@onready var death : Node2D = get_node("Thic")

func _physics_process(delta: float) -> void:
	super(delta)
	circle.rotation_degrees += 360 * delta
	if ammo > 0:
		modulate = Color(255,255,0)
		death.show()
	else:
		modulate = Color(255,255,255)
		death.hide()

func shoot()->Bullet:
	var new_bullet = create_bullet(LYRISBULLET,spawnpoint.global_position,global_rotation_degrees)
	new_bullet.global_rotation_degrees += (Globals.rng.randf_range(-spread,spread))
	return new_bullet
