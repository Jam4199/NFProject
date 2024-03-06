extends EnemyState

var phase_time : float = 6
var shot_cooldown : float = 0.2
var spread_turn : float = 10

var phase_timer = 0
var shot_timer = 0

var subweps : Array[EnemyWeapon] = []
var mainwep : EnemyWeapon
var spreadwep : EnemyWeapon
var anim : AnimationPlayer


func enemy_ready():
	var wepname : String = "SubWep"
	for n in range(0,9):
		subweps.append(get_node("%" + wepname + str(n)))
	mainwep = get_node("%MainWep")
	anim = get_node("%SpriteAnim")
	spreadwep = get_node("%SpreadWep")

func state_enter():
	spreadwep.rotation = 0
	phase_timer = phase_time
	shot_timer = shot_cooldown
	

func state_exit():
	spreadwep.rotation = 0




func state_process(delta:float):
	phase_timer -= delta
	shot_timer -= delta
	if shot_timer <= 0:
		spreadwep.global_rotation_degrees += spread_turn
		spreadwep.shoot(true)
		shot_timer = shot_cooldown
	
	if phase_timer <= 0:
		emit_signal("state_change","Rush")
	
	return
	
	
	
	
	
	










