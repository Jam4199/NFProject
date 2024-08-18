extends CharacterBody2D
class_name Character

@export var hitbox_radius : float = 40

@export_group("Base Stats")
@export var base_health : float = 100
@export var base_attack : float = 10
@export var base_defence : float = 10
@export var line_position : line = line.FRONT
enum line{FRONT, MID, BACK}


@export_group("Movement")
@export var base_speed : float = 120
@export var action_slow : float = 0.5
@export var hurt_slow : float = 0.5


@onready var controller : Controller = get_node("Controller")
@onready var sprite : SpriteController = get_node("Sprite")

#team
enum {LEFT = -1, RIGHT = 1}
var side : int = 0

#control
var move_target : Vector2
var action_queue : Action
var action_target : Character

#stats
var max_hp : float = 100
var current_hp : float = 100
var attack : float = 10
var defence : float = 10


#timers
var hurt_slow_timer : float = 0
var action_slow_timer : float = 0
var action_cooldown_timer : float = 0
var taunt_timer : float = 0

#knockback
var knockback_timer : float = 0
var knockback_value : float = 0
var knockback_moved : float = 0
var knockback_direction := Vector2.ZERO

var active_combat : bool = false

func _ready():
	sprite.character = self



"""
active
"""

func _physics_process(delta: float) -> void:
	if not active_combat:
		return

	if not is_alive():
		return
	#timers
	if hurt_slow_timer > 0:
		hurt_slow_timer -= delta
	if action_slow_timer > 0:
		action_slow_timer -= delta
	if action_cooldown_timer > 0:
		action_cooldown_timer -= delta
	if taunt_timer > 0:
		taunt_timer -= delta
	
	
	#reset values
	move_target = position
	action_queue = null
	action_target = null
	
	controller.character_process(delta,self)
	
	if action_cooldown_timer <= 0 and action_queue != null:
		act(delta)

	
	move(delta)
	
	sprite.active_animation(delta)


func move(delta):
	
	#speed
	var speed : float = base_speed
	var speed_mods : Array[float] = [1]
	if hurt_slow_timer > 0:
		speed_mods.append(hurt_slow)
	if action_slow_timer > 0:
		speed_mods.append(action_slow)
	for speed_mod in speed_mods:
		speed *= speed_mod
	
	#direction
	var direction := Vector2.ZERO
	if move_target != null:
		direction = Vector2.from_angle(position.angle_to_point(move_target))
		if position.distance_to(move_target) <= speed * delta:
			speed = position.distance_to(move_target)

	
	velocity = speed * direction
	velocity += knockback(delta)
	move_and_slide()


func act(delta):
	action_queue.act(self,action_target)
	
	action_cooldown_timer = action_queue.action_cooldown
	
	var facing : int = 1
	if position.x > action_target.position.x:
		facing = -1
	sprite.play_action(action_queue.animation,facing,action_queue.action_cooldown)
	
	return

func knockback(delta) -> Vector2:
	var new_knockback := Vector2.ZERO
	if knockback_timer > 0:
		knockback_timer -= delta
		if (knockback_value + knockback_moved) * delta >= knockback_value:
			new_knockback = (knockback_value) * knockback_direction
			knockback_timer = 0
		else:
			new_knockback = (knockback_moved + knockback_value) * knockback_direction
		knockback_moved += new_knockback.length()
	
	return new_knockback

func apply_knockback(value : float, direction : Vector2):
	knockback_direction = direction
	if value < knockback_value:
		return
	knockback_value = value
	knockback_timer = 0.5
	knockback_moved = 0
	

"""
stats
"""

func reset_timers():
	knockback_timer = 0
	taunt_timer = 0
	hurt_slow_timer = 0
	action_cooldown_timer = 0
	action_slow_timer = 0

func reset_stats():
	max_hp = base_health
	full_heal()
	attack = base_attack
	defence = base_defence


func full_heal():
	current_hp = max_hp

func take_damage(damage : Damage):
	
	var damage_value : float = 0
	var new_def = defence - damage.pen
	if new_def < 0:
		new_def = 0
	damage_value += damage.value
	damage_value -= new_def
	if damage_value < 0:
		damage_value = 0 
	if damage_value > 0:
		sprite.hurt_animation()
	current_hp -= damage_value
	
	if current_hp <= 0:
		current_hp = 0
		death()

func take_heal(heal : float):
	current_hp += heal
	if current_hp > max_hp:
		current_hp = max_hp

func battle_start():
	reset_timers()

func battle_end():
	reset_stats()
	reset_timers()

func death():
	sprite.play_death()
	print("dies")
	return

func is_alive() -> bool:
	return current_hp > 0


















