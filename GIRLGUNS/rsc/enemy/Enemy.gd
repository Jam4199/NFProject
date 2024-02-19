extends Area2D
class_name Enemy

@onready var sprite : Node2D = get_node("%Sprite")
@onready var anim : AnimationPlayer = get_node("Anim")

@export var base_max_hp : float = 1000
@export var base_speed : float = 100
@export var base_attack : float = 100
@export_enum("Large","Mid","Small") var world_layer : int = 0
@export var base_knockback_return : float = 40

var max_hp : float
var current_hp : float
var speed : float
var attack : float
var knockback_return : float
var kb_resist : float
var kb_queue : Array[Vector2] = []

var bullet_phase : bool = false
var damage_immune : bool = false
var knockback_immune : bool = false

func _ready():
	area_entered.connect(Callable(self,"bullet_entered"))
	monitorable = false
	monitoring = false


func _physics_process(delta):
	if kb_queue!= []:
		apply_knockback()
	if kb_resist > 0:
		kb_resist -= knockback_return * delta
		if kb_resist < 0:
			kb_resist = 0

func spawn():
	update_stats()
	current_hp = max_hp
	kb_resist = 0
	monitoring = true

func update_stats():
	max_hp = base_max_hp
	if current_hp > max_hp:
		current_hp = max_hp
	knockback_return = base_knockback_return
	
	speed = base_speed
	attack = base_attack

func bullet_entered(bullet : Bullet):
	if not bullet is Bullet:
		return
	if bullet_phase:
		return
	
	bullet.hit(self)
	return

func take_knockback(direction : Vector2, distance : float, threshold : float):
	if knockback_immune:
		return
	if threshold > kb_resist:
		kb_queue.append(direction * distance)
		kb_resist += threshold
		return
	elif threshold * 2 < kb_resist:
		return
	else:
		var kb_mod : float = 1 - ((kb_resist - threshold) / threshold)
		distance *= kb_mod
		kb_queue.append(direction * (distance * kb_mod))
		kb_resist += (threshold * kb_mod)
	
	return

func apply_knockback():
	for kb in kb_queue:
		global_position += kb
	kb_queue = []
	return

func take_damage(damage : float):
	if damage_immune:
		damage = 0
	if damage <= 0:
		return
	damaged_effect()
	current_hp -= damage
	if current_hp <= 0:
		death()
	return

func damaged_effect():
	anim.play("red_blink")
	return

func death():
	queue_free()
