extends EnemyWeapon
class_name EaterEye

const EBEEM = preload("res://rsc/enemy/Enemies/Eater/EBEEM.tscn")

@onready var warning : AttackWarning = get_node("AttackWarning")
@onready var sprite : Sprite2D = get_node("Sprite")
@onready var anim : AnimationPlayer = get_node("AnimationPlayer")

var one_shot : bool = false

var charge_timer : float = 0
var charge_allowance : float = 0.2
var current_beem : PackedScene = EBEEM
var delay_timer : float = 0.5


signal delay_finished

func _ready() -> void:
	super()
	#spawn()
	#charge_beem()

func spawn():
	anim.play("spawn")

func shoot(force : bool = false, boolet : PackedScene = EBEEM) -> EnemyBullet:
	if cooldown_time <= 0 and force == false:
		return
	var new_bullet : EnemyBullet = boolet.instantiate()
	Globals.add_enemy_bullet(new_bullet)
	new_bullet.global_position = global_position
	new_bullet.global_rotation = global_rotation
	cooldown_timer = cooldown_time
	new_bullet.damage *= bullet_damage_mult
	new_bullet.speed *= bullet_speed_mult
	return new_bullet

func _physics_process(delta: float) -> void:
	if delay_timer > 0:
		delay_timer -= delta
		if delay_timer <= 0:
			emit_signal("delay_finished")
	
	if charge_timer > 0:
		charge_timer -= delta
		if charge_timer <= 0:
			shoot(true, current_beem)
	return

func charge_beem(charge_time : float = 2, allowance : float = 0.2, beem : PackedScene = EBEEM, width : float = 60):
	if delay_timer > 0:
		await delay_finished
	charge_timer = charge_time
	charge_allowance = allowance
	warning.warning_time = charge_time
	warning.warning_width = width
	warning.start()
	current_beem = beem


