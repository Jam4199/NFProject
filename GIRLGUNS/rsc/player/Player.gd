extends CharacterBody2D
class_name Player

@export var speed : float = 300
@export var dash_time : float = 0.1
@export var dash_speed_mult : float = 2
@export var dash_invul : float = 0.5
@export var dash_cooldown : float = 0.3

@onready var weapon_manager : WeaponManager = get_node("WeaponManager")

var movement_input : bool = false
var attack_input : bool = false
var attack_command : bool = false

var dashing : bool = false
var dash_timer : float = 0
var dash_cooldown_timer : float = 0


func _physics_process(delta: float) -> void:
	timers(delta)
	movement()
	weapon_change()
	aim()
	attack()
	

func timers(delta : float):
	if dash_timer > 0:
		print(str(dash_time))
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	
	return

func movement():
	
	if movement_input:
		var direction :=  Vector2(Input.get_axis("player_left", "player_right"),(Input.get_axis("player_up", "player_down")) )
		velocity = direction * speed
	
	if Input.is_action_just_pressed("dash"):
		print("detected")
		dash_input()
	if dashing:
		velocity *= dash_speed_mult
	
	move_and_slide()
	if not dashing:
		velocity = Vector2(0,0)
	return


func dash_input():
	if dashing:
		print("already_dashing")
		return
	if dash_cooldown_timer > 0:
		print("dash_cooldown")
		return
	
	dashing = true
	dash_timer = dash_time
	dash_cooldown_timer = dash_time + dash_cooldown
	print("dash start")
	return


func weapon_change():
	if Input.is_action_just_pressed("weapon_1"):
		weapon_manager.change_weapon(0)
	if Input.is_action_just_pressed("weapon_2"):
		weapon_manager.change_weapon(1)
	if Input.is_action_just_pressed("weapon_3"):
		weapon_manager.change_weapon(2)
	if Input.is_action_just_pressed("weapon_left"):
		weapon_manager.weapon_left()
	if Input.is_action_just_pressed("weapon_right"):
		weapon_manager.weapon_right()
	
	
	return


func aim():
	if not attack_input:
		return
	weapon_manager.look_at(get_global_mouse_position())


func attack():
	if attack_input:
		if Input.is_action_pressed("attack"):
			attack_command = true
		else:
			attack_command = false
	
	weapon_manager.attack(attack_command)
	attack_command = false
	return

