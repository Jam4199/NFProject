extends CharacterBody2D
class_name Character

@onready var sprite = get_node("SpriteManager")
@onready var stat = get_node("StatManager")
@onready var hitbox = get_node("Hitbox")
@onready var stancemanager = get_node("StanceManager")

@export_group("Stats")
@export var base_speed : float = 200
@export var hitbox_radius : float = 30

@export_group("Team")
@export_range(1,9) var default_position : int = 5 #numkeys with 1/4/7 in front

var move_target_position : Vector2 #define with controller
var lock_time : float =  0
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


func _physics_process(delta: float) -> void:
	if not field_activated:
		return
	

	velocity = Vector2(0,0)
	timers(delta)
	
	if stat.is_controlled():
		stat.alternate_control()
	else:
		stancemanager.control()
	
	var knockbacks : Array = []
	emit_signal("knockback_check",knockbacks)
	for knockback in knockbacks:
		velocity += knockback
	
	var speed_mods : Array = []
	emit_signal("speed_mod_check",speed_mods)
	var final_speed : float = base_speed
	for speed_mod in speed_mods:
		final_speed *= speed_mod
	if final_speed * delta > position.distance_to(move_target_position):
		final_speed = position.distance_to(move_target_position) * delta 
	var movement_velocity : Vector2 = Vector2.from_angle(position.angle_to_point(move_target_position)) * final_speed
	
	velocity += movement_velocity
	
	move_and_slide()

func timers(delta : float):
	return

func recieve_damage(damage):
	
	if not field_activated:
		print("damage ignored")
		return
	emit_signal("before_damage_taken", damage)
	stat.recieve_damage(damage)
	emit_signal("after_damage_taken")
	
func is_alive() -> bool:
	return stat.alive

func died():
	play_animation("death")
	return


func play_animation(anim : String):
	#print("bop")
	sprite.play_animation(anim)
