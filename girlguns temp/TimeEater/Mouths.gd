extends Enemy
class_name Mouth

@onready var wep : TSubWep = get_node("%Subwep")

var master : Eater
var attachment : Node2D
var attached : bool = true

var alive : bool = true

var partner : Mouth

func attach():
	knockback_immune = true
	state_input("interrupt")
	get_parent().remove_child(self)
	attachment.add_child(self)
	attached = true
	position = Vector2(0,0)
	rotation = 0


func detach():
	if not alive:
		return
	knockback_immune = false
	var current_position = global_position
	var current_rotation = global_rotation
	get_parent().remove_child(self)
	Globals.add_enemy(self)
	global_position = current_position
	global_rotation = current_rotation
	attached = false
	
func launch():
	detach()
	state_input("launch")

func take_damage(damage : float):
	if not alive:
		return
	super(damage)
	master.take_damage(damage)
	

func toggle(thing : bool):
	if thing and alive:
		visible = true
		set_deferred("monitoring",true)
		set_deferred("monitorable",true)
	else:
		visible = false
		set_deferred("monitoring",false)
		set_deferred("monitorable",false)
	

func death():
	set_deferred("monitoring",false)
	set_deferred("monitorable",false)
	attach()
	visible = false
	alive = false

