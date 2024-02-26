extends CharacterBody2D
class_name Player

@export var max_hp : float = 1000
@export var speed : float = 300
@export var dash_max : int = 3
@export var dash_time : float = 0.1
@export var dash_speed_mult : float = 2.5
@export var dash_invul : float = 0.5
@export var dash_cooldown : float = 1



@onready var weapon_manager : WeaponManager = get_node("WeaponManager")
@onready var hitbox : Area2D = get_node("Hitbox")

var movement_input : bool = false
var attack_input : bool = false
var attack_command : bool = false

var dash_count : int = 0
var dashing : bool = false
var dash_timer : float = 0
var dash_cooldown_timer : float = 0
var dash_invul_timer : float = 0

var current_hp : float = max_hp

func _ready() -> void:
	hitbox.connect("area_entered",Callable(self,"recieve_bullet"))
	current_hp = max_hp

func _physics_process(delta: float) -> void:
	timers(delta)
	movement()
	weapon_change()
	aim()
	attack()


func timers(delta : float):
	if dash_timer > 0:
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false
	if dash_invul_timer > 0:
		dash_invul_timer -= delta
	
	if dash_count < dash_max:
		dash_cooldown_timer += delta
		if dash_cooldown_timer >= dash_cooldown:
			dash_count += 1
			dash_cooldown_timer = 0
	else:
		dash_cooldown_timer = 0
	
	return

#movement and attacking
func movement():
	
	if movement_input:
		var direction :=  Vector2(Input.get_axis("player_left", "player_right"),(Input.get_axis("player_up", "player_down")) )
		velocity = direction * speed
	
	if Input.is_action_just_pressed("dash"):
		dash_input()
	if dashing:
		velocity *= dash_speed_mult
	
	move_and_slide()
	if not dashing:
		velocity = Vector2(0,0)
	return


func dash_input():
	if dashing:
		
		return
	if dash_count <= 0:
		
		return
	dashing = true
	dash_count -= 1
	dash_timer = dash_time
	dash_invul_timer = dash_invul
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

#stat control

func spawn():
	current_hp = max_hp

#taking hits
func take_damage(damage : float):
	current_hp -= damage

	if current_hp <= 0:
		death()
	return

func recieve_bullet(hurtbox : HurtBox):
	if dash_invul_timer > 0:
		print("dodged")
		return
	hurtbox.hit(self)
	return

func death():
	return
