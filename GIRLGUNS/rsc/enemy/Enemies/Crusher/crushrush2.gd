extends EnemyState


@export var attack_time : float = 0.3
@export var attack_distance : float = 400


var attack_timer : float = 0
var dash_counter : int = 3
var dash_count : int = 3

@onready var hurtbox : HurtBox = get_node("Hurtbox")

func state_enter():
	attack_timer = 0
	
	hurtbox.activate()

func state_exit():
	hurtbox.deactivate()

func state_input(input : String):
	match input:
		"interrupt":
			emit_signal("state_change","crushchase")

func state_process(delta : float):
	unit.global_position += (Vector2.from_angle(unit.global_rotation)) * (attack_distance * (1.0/attack_time) * delta)
	attack_timer += delta
	if attack_timer >= attack_time:
		dash_counter -= 1
		if dash_counter <= 0:
			emit_signal("state_change","crushchase")
		else:
			dash_counter = dash_count
			emit_signal("state_change","crushcharge")
