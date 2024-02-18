extends Area2D
class_name Enemy

@export var base_max_hp : float = 1000
@export var base_speed : float = 100
@export var base_attack : float = 100
@export_enum("Large","Mid","Small") var world_layer : int = 0

var max_hp : float
var current_hp : float
var speed : float
var attack : float

var bullet_phase : bool = false
var damage_immune : bool = false

func _ready():
	area_entered.connect(Callable(self,"bullet_entered"))
	monitorable = false
	monitoring = false

func spawn():
	update_stats()
	current_hp = max_hp
	monitoring = true

func update_stats():
	max_hp = base_max_hp
	if current_hp > max_hp:
		current_hp = max_hp

func bullet_entered(bullet : Bullet):
	if not bullet is Bullet:
		return
	if bullet_phase:
		return
	
	bullet.hit(self)
	return

func take_damage(damage : float):
	if damage_immune:
		damage = 0
	current_hp -= damage
	if current_hp <= 0:
		death()
	return

func death():
	queue_free()
