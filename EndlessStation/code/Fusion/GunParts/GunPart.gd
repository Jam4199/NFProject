extends Node2D
class_name GunPart

@export var cooldown_sec : float = 0.2
@export var bullet : PackedScene
@export var damage : float = 10
@export var accuracy_deg : float = 0

var current_cooldown : float = 0

func _ready() -> void:
	if not bullet.instantiate() is Bullet:
		bullet = null
		print("invalid bullet")

@export_group("Bullet")

@export var speed : float = 100
@export var accel : float = 0
@export var accel_cap : float = 360
@export var curve_deg : float = 0
@export var curve_cap : float = 90

var rng = RandomNumberGenerator.new()

func _physics_process(delta: float) -> void:
	if current_cooldown > 0:
		current_cooldown -= Settings.static_delta





func fire_bullet():
	if current_cooldown > 0:
		return
	
	if bullet == null:
		print("no bullet found")
	var new_bullet : Bullet = bullet.instantiate()
	BulletManager.add_player_bullet(new_bullet)

	new_bullet.global_position = global_position
	new_bullet.global_rotation = new_bullet.get_angle_to(get_global_mouse_position())
	new_bullet.global_rotation_degrees += rng.randf_range(-accuracy_deg/2.0,accuracy_deg/2.0)
	new_bullet.velocity = Vector2(cos(new_bullet.global_rotation), sin(new_bullet.global_rotation)) * speed * Settings.static_delta
	new_bullet.accel = accel
	new_bullet.accel_cap = accel_cap
	new_bullet.curve_deg = curve_deg
	new_bullet.curve_cap = curve_cap
	new_bullet.damage = damage
	
	new_bullet.fired = true
	
	current_cooldown = cooldown_sec


