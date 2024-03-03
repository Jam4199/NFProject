extends EnemyState

@onready var warning : AttackWarning = get_node("AttackWarning")

var charge_time : float = 3
var charge_timer : float = 0
var shot : bool = false

var subweps : Array[EnemyWeapon] = []
var mainwep : EnemyWeapon
var anim : AnimationPlayer

func enemy_ready():
	var wepname : String = "SubWep"
	for n in range(0,6):
		subweps.append(get_node("%" + wepname + str(n)))
	mainwep = get_node("%MainWep")
	anim = get_node("%SpriteAnim")

func state_enter():
	anim.play("charging")
	warning.start()
	charge_timer = charge_time
	shot = false
	return

func state_end():
	warning.end()

func state_process(delta : float):
	charge_timer -= delta
	
	if charge_timer > 0.5:
		unit.look_at(Globals.player.global_position)
	
	if charge_timer <= 0 and not shot:
		blast()
		
	
	return
	

func blast():
	shot = true
	mainwep.shoot()
	anim.play("BEEM")
	await anim.animation_finished
	emit_signal("state_change","Chase")
	return
