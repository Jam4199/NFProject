extends EnemyState
@onready var warning : AttackWarning = get_node("AttackWarning")

@export var charge_time : float = 1
@export var allowance : float = 0.2
var current_timer : float = 0

@export var cooldown : float = 2
var cooldown_timer : float = 0

func state_enter():
	warning.warning_time = charge_time
	warning.start()
	current_timer = charge_time

func state_exit():
	warning.end()

func state_allow()->bool:
	if cooldown_timer > 0:
		return false
	return true

func state_process(delta : float):
	current_timer -= delta
	if current_timer >= charge_time * allowance:
		unit.look_at(Globals.player.global_position)
	if current_timer <= 0:
		cooldown_timer = cooldown
		emit_signal("state_change","crushrush")
	return

func _physics_process(delta: float) -> void:
	if cooldown_timer >= 0:
		cooldown_timer -= delta



func state_input(input : String):
	
	match input:
		"interrupt":
			emit_signal("state_change","Chase")
	return
