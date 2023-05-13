extends Area2D


var SPEED = 200.0



@onready var THEBEAM : Area2D = get_node("THEBEAM")
@onready var pointer : Line2D = get_node("Pointer")
@onready var meter : TextureProgressBar = get_node("CooldownMeter")
@onready var bordercheck = get_node("BorderCheck")
@onready var unexister = get_node("Unexister")
@onready var unexistparts : CPUParticles2D = get_node("UnexistParts")
@onready var ramtimer : Timer = get_node("RamTimer")

@onready var left : RayCast2D = get_node("%-x")
@onready var right : RayCast2D = get_node("%+x")
@onready var up : RayCast2D = get_node("%-y")
@onready var down : RayCast2D = get_node("%+y")


var cooldown = 0
var ammo : int = 3
var dead : bool = false
var focused : bool = false

var ramming := false


signal weapon_fired(victims : Array)
signal freeze_fired(victims : Array)
signal oof
signal rammed(roadkill : Enemy)


func _ready() -> void:
	connect("area_entered", Callable(self,"player_oof"))
	unexister.connect("rammed",Callable(self,"enemy_rammed"))
	unexister.connect("slowo", Callable(self, "slowo"))
	return




func _physics_process(delta: float) -> void:
	
	meter.global_position = global_position - Vector2(32,32)
	
	if dead:
		return
	
	if cooldown >= 0:
		cooldown -= delta
		meter.value = cooldown * 100
		if cooldown <= 0:
			pointer.visible = true
			if ammo <= 0:
				pointer.default_color = Color(0,0,255)
	
	if ramming:
		var ram_velocity = Vector2(cos(global_rotation),sin(global_rotation)) * 600 * delta
		
		var space_state = get_world_2d().direct_space_state
		var edge_check = PhysicsRayQueryParameters2D.create(global_position, global_position + ram_velocity + (ram_velocity.normalized() * 15), 1)
		var edge_check_result = space_state.intersect_ray(edge_check)
		if edge_check_result == {}:
			global_position += ram_velocity

		return
	
	var direction = Vector2()
	direction.x = Input.get_axis("player_left", "player_right")
	direction.y = Input.get_axis("player_up", "player_down")
	focused = Input.is_action_pressed("focus")
	
	var velocity : Vector2

	var x = direction.x
	if x > 0 and right.get_collider() != null:
		print(right.get_collider().name)
		direction.x = 0
	if x < 0 and left.get_collider() != null:
		direction.x = 0
	var y = direction.y
	if y > 0 and down.get_collider() != null:
		direction.y = 0
	if y < 0 and up.get_collider() != null:
		direction.y = 0
	direction = direction.normalized()
	
	
	
	if direction != Vector2(0,0) :
		velocity = direction.normalized() * SPEED
		if focused:
			velocity *= 0.5
		global_position += velocity * delta
		#meter.rotation = -global_rotation
		bordercheck.global_position = global_position
	
	rotation = global_position.direction_to(get_global_mouse_position()).angle()
	
	
	if Input.is_action_just_pressed("player_freeze"):
		fire_freeze()
	
	if Input.is_action_just_pressed("player_shoot"):
		fire_weapon()

var oof_this_turn := false

func player_oof(bullet : Bullet):
	if dead:
		return
	if oof_this_turn:
		return
	oof_this_turn = true
	bullet.despawn()
	emit_signal("oof")
	await get_tree().create_timer(0.5,false).timeout
	oof_this_turn = false
	

func fire_freeze():
	if cooldown > 0:
		return
	
	var beam_contact = THEBEAM.get_overlapping_areas()
	emit_signal("freeze_fired",beam_contact)
	enter_cooldown(4)


func fire_weapon():
	
	if cooldown > 0:
		return
		
	if ammo == 0:
		ram()
		return
	
	var beam_contact = THEBEAM.get_overlapping_areas()
	emit_signal("weapon_fired",beam_contact)
	
	ammo -= 1
	
	enter_cooldown(3)
	return

func enter_cooldown(new_cooldown : float):
	pointer.hide()
	cooldown = new_cooldown
	meter.max_value = new_cooldown * 100
	meter.value = new_cooldown * 100

func die():
	visible = false
	dead = true

func ram():
	ramming = true
	unexister.ramming = true
	unexister.set_deferred("monitoring", true)
	set_deferred("monitoring", false)

	ramtimer.start(0.2)
	await ramtimer.timeout

	ramming = false

	set_deferred("monitoring", true)

	kaboom()

	return

func enemy_rammed(roadkill : Enemy):
	emit_signal("rammed", roadkill)

func kaboom():
	enter_cooldown(2)
	unexister.set_deferred("monitoring", true)
	unexistparts.emitting = true
	await get_tree().create_timer(4,false).timeout
	unexistparts.emitting = false
	await get_tree().create_timer(1,false).timeout
	unexister.set_deferred("monitoring", false)

func slowo():
	SPEED *= 0.999
	if SPEED < 100:
		SPEED = 50
	
