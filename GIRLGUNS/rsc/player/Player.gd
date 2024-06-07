extends CharacterBody2D
class_name Player

const PLAYERHIT : PackedScene = preload("res://rsc/player/PlayerHit.tscn")

@export var max_hp : float = 1000
@export var speed : float = 300
@export var dash_max : int = 3
@export var dash_time : float = 0.3
@export var dash_speed_mult : float = 2.5
@export var dash_invul : float = 0.5
@export var dash_cooldown : float = 1

@export var level_cooldown : float = 0.5
var level_cooldown_timer = 0

@export_group("stuff")
@export var hp_gradient : GradientTexture1D = GradientTexture1D.new()

@onready var weapon_manager : WeaponManager = get_node("WeaponManager")
@onready var hitbox : Area2D = get_node("Hitbox")
@onready var p_collector = get_node("PickupCollector")
@onready var p_attractor = get_node("PickupAttractor")
@onready var spritestuff : SpriteStuff = get_node("SpriteStuff")
@onready var hp_line : Line2D = get_node("HPLine")
@onready var current_hp_line : Line2D = get_node("HPLine/CurrentHPLine")
@onready var anim : AnimationPlayer = get_node("AnimationPlayer")
@onready var starbarr : Sprite2D = get_node("StarBarr")

var player_damage : float = 0
var player_reload : float = 0

var movement_input : bool = false
var attack_input : bool = false
var attack_command : bool = false

var dash_charge_multiplier : float = 1
var dash_count : int = 0
var dashing : bool = false
var dash_timer : float = 0
var dash_cooldown_timer : float = 0
var dash_invul_timer : float = 0

var current_hp : float = max_hp

var exp_requirement : float = 10
var current_exp : float = 0
var current_level : int = 1

var dead : bool = false

func _ready() -> void:
	hitbox.connect("area_entered",Callable(self,"recieve_bullet"))
	p_attractor.connect("area_entered",Callable(self, "pickup_attract"))
	p_collector.connect("area_entered", Callable(self, "pickup_collect"))
	current_hp = max_hp
	anim.play("float")

func _physics_process(delta: float) -> void:
	
	timers(delta)
	if dead:
		return
	movement()
	weapon_change()
	aim()
	attack()
	


func timers(delta : float):
	if level_cooldown_timer > 0:
		level_cooldown_timer -= delta
	if dash_timer > 0:
		dash_timer -= delta * dash_charge_multiplier
		if dash_timer <= 0:
			dashing = false
	if dash_invul_timer > 0:
		dash_invul_timer -= delta
	
	if dash_invul_timer > 0.2:
		starbarr.modulate.a = 1
	elif dash_invul_timer > 0.05:
		starbarr.modulate.a = ((dash_invul_timer - 0.05)/0.15)
	elif dash_invul_timer <= 0.0:
		starbarr.modulate.a = 0
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
	if dead:
		velocity = Vector2(0,0)
		return
	
	var direction : Vector2 = Vector2(0,0)
	if movement_input:
		direction =  Vector2(Input.get_axis("player_left", "player_right"),(Input.get_axis("player_up", "player_down")) )
		velocity = direction * speed
		if direction.x != 0:
			if direction.x > 0:
				spritestuff.face(SpriteStuff.RIGHT)
			if direction.x < 0:
				spritestuff.face(SpriteStuff.LEFT)
		else:
			if direction.y < 0:
				spritestuff.face(SpriteStuff.BACK)
			else:
				spritestuff.face(SpriteStuff.FRONT)
	
	if Input.is_action_just_pressed("dash"):
		dash_input()
	if dashing:
		velocity *= dash_speed_mult
	
	move_and_slide()
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

func heal(amount : float):
	var heal_amount = max_hp * (amount/100)
	current_hp += heal_amount
	if current_hp > max_hp:
		current_hp = max_hp
		hp_line.visible = false
	update_hp_line()

func gain_exp(amount : float):
	current_exp += amount
	if current_exp >= exp_requirement and level_cooldown_timer <= 0:
		level_cooldown_timer = level_cooldown
		level_up()
	return

func level_up():
	current_exp -= exp_requirement
	current_level += 1
	exp_requirement += ceili(float(exp_requirement) * 0.1)
	Globals.world.upgrades.level_up()

func update_hp_line():
	current_hp_line.default_color = hp_gradient.gradient.sample(1.0 - (current_hp)/(max_hp))
	if current_hp > 0:
		current_hp_line.points[1].x = (current_hp/max_hp) * 40

#taking hits
func take_damage(damage : float):
	var new_effect : Effect = Globals.add_effect(PLAYERHIT.instantiate())
	new_effect.global_position = global_position
	current_hp -= damage
	hp_line.visible = true
	update_hp_line()
	if current_hp <= 0:
		call_deferred("death")
	return

func recieve_bullet(hurtbox : HurtBox):
	if dead:
		return
	if dash_invul_timer > 0:
		print("dodged")
		return
	hurtbox.hit(self)
	return

func death():
	dead = true
	movement_input = false
	attack_input = false
	anim.play("death")
	velocity = Vector2(0,0)
	Globals.player_death()
	return

#pickups
func pickup_attract(pickup : Pickup):
	pickup.attracted = true

func pickup_collect(pickup : Pickup):
	pickup.picked_up(self)
	match pickup.type:
		0:
			heal(pickup.value)
		1:
			gain_exp(pickup.value)
	return

