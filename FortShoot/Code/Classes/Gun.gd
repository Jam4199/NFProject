extends Node2D
class_name Gun

@export var player_owned : bool = true
@export var bullet_scene : PackedScene

@export var spawn_position : Node2D = self

@export_group("Gun")
@export var cooldown : float = 0.5
@export var automatic : bool = true
@export var magazine : int = 10
@export var reload_time : float = 1.5
@export var accuracy_degrees : float = 0 # degrees


@export_group("Bullet")
@export var initial_speed : float = 300
@export var initial_curve_deg : float = 0   #degrees/sec
@export var curve_cap : float = 360
@export var accel : float = 0 #speed/s
@export var accel_cap : float = 500
@export var pierce : int = 0

var ammo : int
var cooldown_remaining : float = 0
var reloading : bool = false
var reload_remaining : float = 0

func _ready() -> void:
	if spawn_position == null:
		spawn_position = self
	
	ammo = magazine
	
	return

func _physics_process(delta: float) -> void:
	if reloading:
		reload_remaining -= Globals.static_delta
		if reload_remaining <= 0:
			reload_complete()
	if cooldown_remaining > 0:
		cooldown_remaining -= Globals.static_delta

func fire():
	
	var new_bullet = craft_bullet(bullet_scene, spawn_position)
	fire_bullet(new_bullet)
	ammo -= 1
	cooldown_remaining = cooldown
	return

func reload_start():
	reload_remaining = reload_time
	reloading = true

func reload_interrupt():
	if not reloading:
		return
	reload_remaining = reload_time
	reloading = false

func reload_complete():
	reloading = false
	ammo = magazine


func craft_bullet(scene : PackedScene,spawner : Node2D) -> Bullet:
	var new_bullet : Bullet = scene.instantiate()
	set_bullet_velocity(new_bullet, spawner.global_rotation, initial_speed)
	new_bullet.curve_cap = curve_cap
	new_bullet.curve_deg = initial_curve_deg
	new_bullet.accel = accel
	new_bullet.accel_cap = accel_cap
	new_bullet.pierce = pierce
	add_bullet(new_bullet)
	new_bullet.global_rotation = spawner.global_rotation
	new_bullet.global_position = spawner.global_position
	return new_bullet


func set_bullet_velocity(bullet : Bullet, direction : float, speed : float):
	bullet.velocity = Vector2(cos(direction),sin(direction)) * speed

func add_bullet(bullet : Bullet):
	if player_owned:
		BulletManager.add_player_bullet(bullet)
	else:
		BulletManager.add_enemy_bullet(bullet)

func fire_bullet(bullet : Bullet):
	bullet.fired = true
