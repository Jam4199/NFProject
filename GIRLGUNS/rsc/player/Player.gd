extends CharacterBody2D
class_name Player

@export var speed : float = 300

@onready var weapon_manager : WeaponManager = get_node("WeaponManager")

var movement_input : bool = false
var attack_input : bool = false
var attack_command : bool = false

func _physics_process(delta: float) -> void:
	movement()
	attack()
	

func movement():
	
	if movement_input:
		var direction :=  Vector2(Input.get_axis("player_left", "player_right"),(Input.get_axis("player_up", "player_down")) )
		velocity = direction * speed
	move_and_slide()
	velocity = Vector2(0,0)
	return

func attack():
	if attack_input:
		if Input.is_action_pressed("attack"):
			attack_command = true
		else:
			attack_command = false
		return
	
	weapon_manager.attack(attack_command)
	attack_command = false
	return

