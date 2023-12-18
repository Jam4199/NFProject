extends CharacterBody2D
class_name Character

@onready var sprite = get_node("SpriteManager")
@onready var stats : StatManager = get_node("StatManager")
@onready var hitbox : Area2D = get_node("Hitbox")
@onready var stancemanager : StanceManager = get_node("StanceManager")

@export_group("Stats")
@export var base_speed : float = 200
@export var hitbox_radius : float = 30

@export_group("Team")
@export_range(1,9) var default_position : int = 5 #numkeys with 1/4/7 in front

var move_target_position : Vector2 #define with controller
var moving : bool = true #define with controller
var acting : bool = false #define with action
var action_lock_time : float = 0
var move_lock_time : float = 0
var total_lock_time : float =  0
var walk_anim_lock_time : float = 0

signal speed_mod_check(speed_mods : Array)
signal knockback_check(knockbacks : Array)
signal character_died(Character)

#define with field
enum {LEFT = -1, RIGHT = 1}
var side : int = 0
var field : Field
var on_field : bool = false
var field_activated : bool = false
var face : int = RIGHT

func _ready() -> void:
	
	#stats
	connect("speed_mod_check",Callable(stats,"speed_mod_check"))
	stats.connect("unit_died", Callable(self,"died"))
	#stance
	stats.connect_mods(stancemanager)
	stats.connect("call_passives",Callable(stancemanager,"call_passives"))
	
	
	return

func _physics_process(delta: float) -> void:
	if not field_activated:
		return
	

	velocity = Vector2(0,0)
	timers(delta)
	
	if total_lock_time > 0:
		return
	
	
	
	var knockbacks : Array = []
	emit_signal("knockback_check",knockbacks)
	for knockback in knockbacks:
		velocity += knockback
	
	
	
	if not stats.check_locked():
		if stats.is_controlled():
			stats.alternate_control()
		else:
			stancemanager.control()
		if moving and not move_lock_time > 0:
			velocity += get_movement_velocity(delta)
	
	move_and_slide()

func get_movement_velocity(delta : float) -> Vector2:
	var speed_mods : Array = []
	emit_signal("speed_mod_check",speed_mods)
	var final_speed : float = stats.get_stat("move_speed")
	
	if final_speed * delta > position.distance_to(move_target_position):
		final_speed = position.distance_to(move_target_position) * delta 
	var movement_velocity : Vector2 = Vector2.from_angle(position.angle_to_point(move_target_position)) * final_speed
	
	return movement_velocity

func timers(delta : float):
	if total_lock_time > 0:
		total_lock_time -= delta
		return
	if action_lock_time > 0:
		action_lock_time -= delta
	if move_lock_time > 0:
		move_lock_time -= delta
	return

func recieve_damage(damage):
	
	if not field_activated:
		print("damage ignored")
		return
	emit_signal("before_damage_taken", damage)
	stats.recieve_damage(damage)
	emit_signal("after_damage_taken")
	
func is_alive() -> bool:
	return stats.alive

func can_act() -> bool:
	if action_lock_time > 0:
		return false
	
	return true


func died():
	play_animation("death")
	return

func change_facing(new_facing):
	face = new_facing
	#tell sprite to change direction

func play_animation(anim : String):
	#print("bop")
	sprite.play_animation(anim)
