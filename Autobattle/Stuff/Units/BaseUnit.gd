extends CharacterBody2D
class_name Unit

@onready var unit_controller : UnitController = get_node("UnitController")
@onready var stance_controller : StanceController = get_node("StanceController") #stances
@onready var stat_manager : StatManager = get_node("StatManager") #stats
@onready var sprite_controller : SpriteController = get_node("SpriteController") #spritecontroller

@export_group("Stats")
@export var base_speed : float = 200
@export var hitbox_radius : float = 30

@export_group("Team")
@export_range(1,9) var default_position : int = 5 #numkeys with 1/4/7 in front


#define with field
enum {LEFT = -1, RIGHT = 1}
var side : int = 0
var field : Field
var on_field : bool = false
var field_activated : bool = false

var attack_range : float = 50 : get = get_attack_range


var move_target_position : Vector2 #define with controller
var lock_time : float =  0
var walk_anim_lock_time : float = 0

signal speed_mod_check(speed_mods : Array)
signal knockback_check(knockbacks : Array)
signal unit_died(Unit)

func get_attack_range() -> float:
	var current_stance = stance_controller.current_stance
	if current_stance.basic_attack == null:
		print("FUCK, NO ATTACK")
		return 0
	return current_stance.basic_attack.action_range
	
func _ready() -> void:
	#Actions
	for action in get_node("Actions").get_children():
		if action is Action:
			action.user = self
	
	if stat_manager != null:
		connect("speed_mod_check",Callable(stat_manager,"speed_mod_check"))
		stat_manager.connect("unit_died", Callable(self,"died"))
	
	#StanceController
		if stance_controller != null:
			stat_manager.connect_mods(stance_controller)
			stat_manager.connect("call_passives",Callable(stance_controller,"call_passives"))

	for node in [unit_controller,stance_controller,stat_manager,sprite_controller]:
		if node == null:
			continue
		node.unit = self
		if node.has_method("speed_mod_check"):
			if not is_connected("speed_mod_check", Callable(node,"speed_mod_check")):
				connect("speed_mod_check",Callable(node,"speed_mod_check"))


	return

func _physics_process(delta: float) -> void:
	if not field_activated:
		return
	

	velocity = Vector2(0,0)
	taunt_timer(delta)
	lock_timer(delta)
	if walk_anim_lock_time > 0:
		walk_anim_lock_time -= delta
	
	if not check_locked():
		unit_controller.update()
	else:
		move_target_position = position
	
	var knockbacks : Array = []
	emit_signal("knockback_check",knockbacks)
	for knockback in knockbacks:
		velocity += knockback
	
	var speed_mods : Array = []
	emit_signal("speed_mod_check",speed_mods)
	var final_speed : float = base_speed
	for speed_mod in speed_mods:
		final_speed *= speed_mod
	if final_speed * delta > position.distance_to(move_target_position):
		final_speed = position.distance_to(move_target_position) * delta 
	var movement_velocity : Vector2 = Vector2.from_angle(position.angle_to_point(move_target_position)) * final_speed
	#var movement_velocity : Vector2 = position.move_toward(move_target_position, final_speed)
	#if (position + velocity).distance_to(move_target_position) < final_speed * delta:
	#	movement_velocity = (position + velocity).move_toward(move_target_position, (final_speed * (1 / delta)))#move_target_position * (1 / delta)
	velocity += movement_velocity
	#print("position is " + str(position) + ", moving to " + str(move_target_position) + ", with speed" + str(final_speed) + ", with final velocity = " + str(velocity))
	
	if movement_velocity == Vector2(0,0) or  walk_anim_lock_time > 0:
		sprite_controller.walking = false
		
	else:
		sprite_controller.walking = true
		if movement_velocity.x > 10:
			sprite_controller.walk(RIGHT)
		if movement_velocity.x < -10:
			sprite_controller.walk(LEFT)
	
	
	
	move_and_slide()

func deploy(new_field):
	
	field = new_field
	
	if side != LEFT and side != RIGHT:
		print("no side kaboom")
		return
	
	unit_controller.field = field
		
	stat_manager.deploy()
	sprite_controller.reset()
	sprite_controller.face(-side)
	on_field = true
	return

func exit_combat():
	stat_manager.exit_combat()
	on_field = false

var taunt_time : float = 0
var taunt_instance : int = 0
var taunt_target : Unit

func taunt_timer(delta : float):
	if taunt_instance <= 0:
		taunt_time = 0
		taunt_target = null
		return
	
	if taunt_time > 0:
		taunt_time -= delta
		if taunt_time <= 0:
			taunt_instance = 0
			taunt_target = null

func lock_timer(delta : float):
	if lock_time > 0:
		lock_time -= delta

func initiate_attack(target : Unit):
	if target == taunt_target:
		taunt_instance -= 1
	
	
	if target.position.x < position.x:
		sprite_controller.face(LEFT)
		print("eh")
	if target.position.x > position.x:
		sprite_controller.face(RIGHT)
		print("eh")
	
	walk_anim_lock_time = 0.2
	stance_controller.current_stance.basic_attack.act(target)
	
	return

func check_locked() -> bool:
	if lock_time > 0:
		return true
	if stat_manager.check_locked():
		return true
	if is_alive() == false:
		return true
	return false

func can_attack() -> bool:
	
	return stance_controller.can_attack()

func can_attack_unit(unit : Unit) -> bool:
	
	return stance_controller.can_attack_unit(unit)

signal before_damage_taken(damage : Damage)
signal after_damage_taken(damage : Damage)

func recieve_taunt(target : Unit, timer : float = 1, instances : int = 1):
	taunt_target = target
	taunt_time = timer
	taunt_instance = instances

func recieve_damage(damage : Damage):
	
	if not field_activated:
		print("damage ignored")
		return
	emit_signal("before_damage_taken", damage)
	stat_manager.recieve_damage(damage)
	emit_signal("after_damage_taken")
	
func is_alive() -> bool:
	return stat_manager.alive

func died():
	play_animation("death")
	return

func action_lock(timer : float):
	lock_time = timer

func play_animation(anim : String):
	#print("bop")
	sprite_controller.play_animation(anim)

