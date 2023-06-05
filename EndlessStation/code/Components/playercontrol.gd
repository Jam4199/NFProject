extends Node2D
class_name PlayerControl

@export var movementcontrol : Node2D
@export var rotatecontrol : Node2D
@export var guns : Node2D
@export var weaponcontrol : Node2D
@export var bordercheck : Node2D


var weapon_firing : bool = false

signal move_command(direction : Vector2)
signal rotate_command(direction : Vector2)
signal focus_enter
signal focus_exit
signal fire_weapon
signal alt_fire
signal change_weapon(direction : int)

func _ready() -> void:
	Settings.connect("weapon_fire", Callable(self,"weapon_fire"))
	
	connect("move_command",Callable(movementcontrol,"move_command"))
	connect("focus_enter", Callable(movementcontrol,"focus_enter"))
	connect("focus_exit", Callable(movementcontrol,"focus_exit"))
	
	if weaponcontrol != null:
		connect("alt_fire", Callable(weaponcontrol,"fire_weapon"))
		connect("change_weapon", Callable(weaponcontrol, "change_weapon"))
	
	if guns != null:
		connect("fire_weapon", Callable(guns,"fire"))

func _physics_process(delta: float) -> void:
	
	var direction = Vector2()
	direction.x = Input.get_axis("player_left", "player_right")
	direction.y = Input.get_axis("player_up", "player_down")
	
	if bordercheck != null:
		if bordercheck.has_method("border_check"):
			direction = bordercheck.border_check(direction)
	
	emit_signal("move_command", direction)
	emit_signal("rotate_command", direction)
	
	if weapon_firing:
		if Input.is_action_pressed("weapon_fire"):
			emit_signal("fire_weapon")
			
		else:
			
			weapon_firing = false
	
	if Input.is_action_just_pressed("weapon_next"):
		emit_signal("change_weapon", 1)
	if Input.is_action_just_pressed("weapon_previous"):
		emit_signal("change_weapon", -1)
	

func weapon_fire():
	weapon_firing = true
	
