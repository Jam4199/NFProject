extends EnemyState

var attack_time : float = 0.2
var attack_distance : float = 260


var attack_timer : float = 0


@onready var hurtbox : HurtBox = get_node("Hurtbox")

func state_enter():
	attack_timer = 0
	hurtbox.activate()

func state_exit():
	hurtbox.deactivate()

func state_input(input : String):
	match input:
		"interrupt":
			emit_signal("state_change","Chase")

func state_process(delta : float):
	unit.global_position += (Vector2.from_angle(unit.global_rotation)) * (attack_distance * (1.0/attack_time) * delta)
	attack_timer += delta
	if attack_timer >= attack_time:
		emit_signal("state_change","Chase")
