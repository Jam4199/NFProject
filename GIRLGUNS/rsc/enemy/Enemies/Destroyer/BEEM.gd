extends EnemyState

@onready var warning : AttackWarning = get_node("AttackWarning")

var charge_time : float = 3
var charge_timer : float = 0
var shot : bool = false
var barrage_spread : float = 30
var enraged : bool = false

var subweps : Array[EnemyWeapon] = []
var mainwep : EnemyWeapon
var anim : AnimationPlayer

func enemy_ready():
	var wepname : String = "SubWep"
	for n in range(0,9):
		subweps.append(get_node("%" + wepname + str(n)))
	mainwep = get_node("%MainWep")
	anim = get_node("%SpriteAnim")

func state_enter():
	anim.play("charging")
	warning.start()
	charge_timer = charge_time
	shot = false
	for subwep in subweps:
		var rando : float = Globals.rng.randf_range(0,1)
		if rando < 0.5:
			subwep.rotation_degrees = Globals.rng.randf_range(-barrage_spread,barrage_spread)
		else:
			subwep.look_at(Globals.player.global_position)
	return

func state_end():
	warning.end()

func state_process(delta : float):
	charge_timer -= delta
	
	if charge_timer > 0.5:
		unit.look_at(Globals.player.global_position)
		for subwep in subweps:
			if subwep.cooldown_timer <= 0:
				subwep.shoot()
				subwep.cooldown_timer = 0.3
	
	if charge_timer <= 0 and not shot:
		blast()
		
	
	return
	

func blast():
	shot = true
	mainwep.shoot()
	anim.play("BEEM")
	unit.take_knockback(Vector2.from_angle(global_rotation + PI),50,200,0)
	await anim.animation_finished
	emit_signal("state_change","Chase")
	return

func enrage():
	enraged = true
	charge_time = 2
	warning.warning_time = 2







