extends EnemyState

var phase_time : float = 2
var phase_timer : float = 2

var subweps : Array[EnemyWeapon] = []
var mainwep : EnemyWeapon
var spreadwep : EnemyWeapon
var anim : AnimationPlayer

func enemy_ready():
	var wepname : String = "SubWep"
	for n in range(0,9):
		subweps.append(get_node("%" + wepname + str(n)))
	mainwep = get_node("%MainWep")
	spreadwep = get_node("%SpreadWep")
	anim = get_node("%SpriteAnim")

func state_enter():
	if anim.current_animation != "base":
		anim.play("base")
	phase_timer = phase_time
	for state in unit.states:
		if unit.states[state].has_method("enrage"):
			unit.states[state].enrage()


func state_process(delta:float):
	phase_time -= delta
	if phase_time <= 0:
		emit_signal("state_change","CircleBarrage")
	return











