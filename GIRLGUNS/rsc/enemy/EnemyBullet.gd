extends HurtBox
class_name EnemyBullet

@export var base_speed : float = 600
@export var max_distance : float = 2000
@export var lifetime : float = 3
@export_enum("Large","Mid","Small") var world_layer : int = 0
@export_group("Visuals")
@export var nodes : Array[Node2D]
@export var particles : Array[CPUParticles2D]

var speed : float = base_speed
var dying : bool = false
var total_time : float = 0
var total_distance : float = 0

func _ready() -> void:
	speed = base_speed

func _physics_process(delta: float) -> void:
	
	if dying:
		return
	move(delta)
	total_time += delta
	return

func move(delta : float):
	global_position += (Vector2.from_angle(global_rotation) * (speed * delta))
	total_distance += speed * delta
	if total_distance >= max_distance or total_time >= lifetime:
		bullet_end()
		return

	return

func bullet_end():
	dying = true
	set_deferred("monitorable",false)
	for node in nodes:
		node.visible = false
	for particle in particles:
		particle.emitting = false
	await get_tree().create_timer(2,false,true).timeout
	queue_free()
	return

func hit(player : Player):
	super(player)
	bullet_end()
