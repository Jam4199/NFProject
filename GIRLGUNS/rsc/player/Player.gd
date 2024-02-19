extends CharacterBody2D
class_name Player

@export var speed : float = 300

@onready var weapon_manager : WeaponManager = get_node("WeaponManager")

var movement_input : bool = false
var attack_input : bool = false
var attack_command : bool = false

func _physics_process(delta: float) -> void:
	movement()
	weapon_change()
	aim()
	attack()
	

func movement():
	
	if movement_input:
		var direction :=  Vector2(Input.get_axis("player_left", "player_right"),(Input.get_axis("player_up", "player_down")) )
		velocity = direction * speed
	move_and_slide()
	velocity = Vector2(0,0)
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

