extends Area2D
class_name Enemy

var frozen : bool = false
var player : Area2D

var enabled : bool = false
var dead : bool = false
var shielded : bool = true
@onready var notifier : VisibleOnScreenNotifier2D = get_node("VisibleOnScreenNotifier2D")
@onready var freezetimer : Timer = get_node("%FreezeTimer")
@onready var weaponcontrol : WeaponControl = get_node("WeaponControl")
@onready var shootparts : CPUParticles2D = get_node("ShootParts2")

func _ready() -> void:
	if has_node("Sprite2D"):
		shootparts.modulate = get_node("Sprite2D").modulate
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
	shootparts.emitting = true
	await get_tree().create_timer(0.3).timeout
	weaponcontrol.fire_weapon(slot)
	shootparts.emitting = false

func entered():
	set_deferred("monitorable", true)
	enabled = true
	print("enable")
	shield_drain()
	activate()

func die():
	dead = true
	self.visible = false
	enabled = false
	set_deferred("monitorable", false)
	return

func shield_drain():
	await get_tree().create_timer(10,false).timeout
	get_node("%ShieldBlinker").play("default")
	await get_tree().create_timer(5,false).timeout
	shielded = false
	get_node("Shield").visible = false



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
