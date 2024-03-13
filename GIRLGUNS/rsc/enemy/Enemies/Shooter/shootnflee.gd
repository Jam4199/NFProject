extends EnemyState

var wep : EnemyWeapon
@export var target_distance : float = 300


func enemy_ready():
	wep = get_node("%ShooterWep")

func state_process(delta : float):
	if wep.cooldown_timer <= 0:
		wep.shoot()
	unit.look_at(Globals.player.global_position)
	unit.global_position += Vector2.from_angle(unit.global_rotation + PI) * unit.speed * delta
	if global_position.distance_to(Globals.player.global_position) >= target_distance:
		emit_signal("state_change","shootnhover")







































