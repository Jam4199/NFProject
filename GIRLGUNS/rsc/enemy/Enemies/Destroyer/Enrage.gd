extends EnemyState

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
		




