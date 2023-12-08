extends Node
class_name Action

@export var action_range : float = 50
@export var cooldown : float = 1
@export var lock_time : float = 0.05
@export var action_anim : String = "attack"

@export var sample_damage : Damage


var user : Unit
var remaining_cooldown : float = 0

func _physics_process(delta : float):
	if remaining_cooldown > 0:
		remaining_cooldown -= delta * user.stat_manager.attack_speed

func userstat() -> StatManager:
	return user.stat_manager

func can_attack() -> bool:
	if remaining_cooldown > 0:
		return false
	return true

func can_attack_unit(unit : Unit)->bool:
	
	if unit.is_alive() == false:
		return false
	if unit.position.distance_to(user.position) > action_range + unit.hitbox_radius:
		return false
	
	#check target tags if targettable
	return true

func act(target : Unit):
	remaining_cooldown = cooldown
	user_lock(lock_time)
	action_body(target)
	return

func action_body(target : Unit):
	#insert action here
	return

func user_lock(timer : float):
	user.action_lock(timer)

func get_field() -> Field:
	return user.field

func apply_damage(damage : Damage, target : Unit):
	
	target.recieve_damage(damage)

func play_animation(anim : String = action_anim):
	user.play_animation(anim)
	return

#func fire_projectile(projectile : PackedScene, origin : Vector2, Velocity : Vector2):
#	#make field support this first
#	return

