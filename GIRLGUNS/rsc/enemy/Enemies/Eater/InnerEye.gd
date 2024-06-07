extends Enemy
class_name InnerEye

var master : Eater
var move_target : Vector2 = Vector2(0,0)
var angle_target : float = 0
var angle_targetting : bool = false
var inner_locked : bool = false

@onready var weapon : EaterEye = get_node("Flash/Color/Sprite/EaterEye")

func take_damage(damage : float):
	master.take_damage(damage)

func fade(bah : bool = false):
	monitorable = bah
	monitoring = bah
	if bah:
		modulate.a = 1
	else:
		modulate.a = 0.5

func toggle(thing : bool):
	if thing:
		change_state("eyecontrol")

		return
	change_state("eyefloat")
	

func move_toward(target : Vector2):
	move_target = target
	toggle((true))
	return

func look_toward(target_angle : float):
	angle_target = target_angle
	angle_targetting = true
	toggle(true)
	return
