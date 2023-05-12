extends Node2D
class_name Weapon

signal bullet_made(new_bullet : Bullet)

@export var bullet_scene : PackedScene
@export var bullet_stack : int = 1
@export var stack_speed_gap : float = 5

@export_group("Bullet Mods")
@export var speed : float = 100 #pixel/s
@export var curve : float = 0   #degrees/sec
@export var acceleration : float = 0 #speed/s
@export var min_speed : float = 100
@export var max_speed = 500

@export var spin : bool = false
@export var origin : Vector2
@export var spin_type : int = 0 # 0 = degrees/sec, 1 = arc length
@export var spin_speed: float = 0
	
@export var color : Color = Color8(255,255,255,255)


func fire():
	fire_bullet()


func create_bullet(new_bullet_scene : PackedScene = bullet_scene) -> Bullet:
	var new_bullet : Bullet = new_bullet_scene.instantiate()
	emit_signal("bullet_made",new_bullet)
	return new_bullet

func fire_bullet():
	return

func apply_mods(new_bullet : Bullet):
	new_bullet.speed = speed
	new_bullet.curve = curve
	new_bullet.acceleration = acceleration
	new_bullet.min_speed = min_speed
	new_bullet.max_speed = max_speed
	new_bullet.spin = spin
	new_bullet.spin_type = spin_type
	new_bullet.spin_speed = spin_speed
	new_bullet.modulate = color
	
	return
