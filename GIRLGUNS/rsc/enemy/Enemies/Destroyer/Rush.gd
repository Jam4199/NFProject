extends EnemyState

const SPAWNER = preload("res://rsc/enemy/Enemies/Destroyer/Dchasespawner.tscn")

@onready var warning : AttackWarning = get_node("AttackWarning")


var charge_time : float = 2
var rush_time : float = 0.8
var rush_speed : float = 2500
var aim_allowance : float = 0.5
var charge_timer : float
var rush_timer : float


var charging : bool = true

var anim : AnimationPlayer


func enemy_ready():
	anim = get_node("%SpriteAnim")



func state_enter():
	charge_timer = charge_time
	charging = true
	warning.warning_time = charge_time
	warning.warning_length = rush_speed * rush_time
	warning.start()
	anim.play("charging")

func state_process(delta : float):
	if charge_timer >= aim_allowance:
		unit.look_at(Globals.player.global_position)
	if charging:
		charge_timer -= delta
		if charge_timer <= 0:
			charging = false
			rush_timer = rush_time
			anim.play("base")
			var new_spawner = SPAWNER.instantiate()
			Globals.add_enemy(new_spawner)
			new_spawner.global_position = global_position
			new_spawner.global_rotation = global_rotation
			new_spawner.spawn()
		return
	rush_timer -= delta
	unit.global_position += Vector2.from_angle(unit.global_rotation) * rush_speed * delta
	if rush_timer <= 0:
		emit_signal("state_change","Chase")














