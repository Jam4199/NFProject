extends Area2D
class_name Enemy

var frozen : bool = false
var player : Area2D

var enabled : bool = false
var dead : bool = false
@onready var notifier : VisibleOnScreenNotifier2D = get_node("VisibleOnScreenNotifier2D")
@onready var freezetimer : Timer = get_node("%FreezeTimer")
@onready var weaponcontrol : WeaponControl = get_node("WeaponControl")

func _ready() -> void:
	if owner != null:
		weaponcontrol.connect("bullet_made", Callable(owner, "bullet_made"))
	notifier.connect("screen_entered", Callable(self,"entered"))
	freezetimer.connect("timeout", Callable(self, "freeze_end"))
	add_to_group("Enemies")

func _physics_process(delta: float) -> void:
	if not enabled or dead:
		return
	
	if frozen:
		return
	
	movement(delta)

func fire_weapon(slot : int = 0):
	weaponcontrol.fire_weapon(slot)

func entered():
	set_deferred("monitorable", true)
	enabled = true
	print("enable")
	activate()

func die():
	dead = true
	self.visible = false
	enabled = false
	set_deferred("monitorable", false)
	return


func freeze():
	frozen = true
	freezetimer.start(2)

func freeze_end():
	frozen = false

func movement(delta : float):
	return

func activate():
	return

func enrage():
	return
