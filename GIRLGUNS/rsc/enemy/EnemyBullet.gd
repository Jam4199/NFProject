extends HurtBox

@export var base_speed : float = 600
@export var max_distance : float = 2000
@export var lifetime : float = 3
@export_group("Visuals")
@export var nodes : Array[Node2D]
@export var particles : Array[CPUParticles2D]

var speed : float = base_speed
var dying : bool = false
var total_time : float = 0
var total_distance

func _physics_process(delta: float) -> void:
	speed = base_speed
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

func hit(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		bullet_end()
