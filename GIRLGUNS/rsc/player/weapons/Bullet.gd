extends Area2D
class_name Bullet

@export var base_damage : float = 100
@export var base_speed : float = 600 #distance per second
@export var base_pierce : int = 1
@export var base_aoe : bool = false
@export var base_aoe_size : float = 20
@export var max_distance : float = 2000

@export_group("Visuals")
@export var nodes : Array[Node2D]
@export var particles : Array[CPUParticles2D]
@export_group("Effects")
@export var hit_effect : PackedScene
@export var end_effect : PackedScene
@export_group("Knockback")
@export var kb_active : bool = false
@export_enum("Away","Direction") var kb_direction : int = 1
@export var kb_distance : float = 100
@export var kb_buildup : float = 10
@export_range(0,100) var kb_threshold : float = 30

var damage : float = base_damage
var speed : float = base_speed #distance per second
var pierce : int = base_pierce
var aoe : bool = base_aoe
var aoe_size : float = base_aoe_size
var total_distance : float = 0


signal bullet_hit(hit_count : int)
var hit_count : int = 0
var pierced : Array = []

func _ready() -> void:
	monitoring = false

func _physics_process(delta: float) -> void:
	call_deferred("move", delta)
	return

func move(delta : float):
	global_position += (Vector2.from_angle(global_rotation) * (speed * delta))
	total_distance += speed * delta
	if total_distance >= max_distance:
		bullet_end()
	return

func hit(object : Node2D):
	if object in pierced:
		return
	
	emit_signal("bullet_hit",hit_count)
	
	
	if object.has_method("take_damage"):
		hurt(object)
	
	if object.has_method("take_knockback") and kb_active:
		knockback(object)
	
	hit_count += 1
	pierce -= 1
	if pierce <= 0:
		bullet_end()
	if hit_effect != null:
		create_effect(hit_effect)
	pierced.append(object)
	return

func hurt(object):
	object.take_damage(damage)
	return

func knockback(object):
	var kb_vector : Vector2
	match kb_direction:
		0:
			kb_vector = Vector2.from_angle(Globals.player.global_position.angle_to_point(object.global_position))
		1:
			kb_vector = Vector2.from_angle(global_rotation)
	object.take_knockback(kb_vector,kb_distance,kb_threshold,kb_buildup)
	return

func bullet_end():
	if end_effect != null:
		create_effect(end_effect)
	set_deferred("monitorable",false)
	for node in nodes:
		node.visible = false
	for particle in particles:
		particle.emitting = false
	await get_tree().create_timer(2,false,true).timeout
	queue_free()
	return
	

func create_effect(effect_scene : PackedScene, effect_position : Vector2 = self.global_position, effect_rotation : float = self.global_rotation):
	var new_effect : Node2D = effect_scene.instantiate()
	Globals.add_effect(new_effect)
	new_effect.global_position = effect_position
	new_effect.rotation = effect_rotation
