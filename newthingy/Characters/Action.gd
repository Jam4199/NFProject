extends Node
class_name Action

@export var action_name : String = "Action"
@export var action_target : side = side.ENEMY
@export var action_cooldown : float = 2
@export var action_slow : float = 0.5
@export var action_range : float = 20

enum side{ALLY = 1, ENEMY = -1}

@export_group("Animation")
@export var animation : String = "default_attack"

func act(caster, target):
	return


func create_timer(wait_time : float = 0.1) -> Timer:
	var new_timer = Timer.new()
	new_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	new_timer.one_shot = true
	new_timer.wait_time = wait_time
	add_child(new_timer)
	return new_timer

