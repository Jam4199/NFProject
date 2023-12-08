extends CharacterBody2D

@export var base_jump_speed = 300
@export var base_move_speed = 300
signal speed_add_requested(speed_adds : PackedFloat32Array)
signal speed_mult_requested(speed_mults : PackedFloat32Array)

@export var controller : InputController


var action_state : int = 0
var air_state : int = 0

enum {IDLE, ATTACKING}
enum {GROUNDED, JUMPING, FLOATING, FREEFALL}

func _physics_process(delta: float) -> void:
	
	gravity(delta)
	
	move_command()
	
	
	move_and_slide()


func gravity(delta : float):
	if air_state != GROUNDED and is_on_floor():
		air_state = GROUNDED
	if air_state != FREEFALL and not is_on_floor():
		air_state = FREEFALL
	
	if not is_on_floor() and air_state == FREEFALL:
		if velocity.y < Globals.termincal_velocity:
			velocity.y += Globals.gravity

func move_command():
	var direction : Vector2 = controller.get_dpad()
	var speed_adds : PackedFloat32Array= []
	var speed_mults : PackedFloat32Array = [1]
	emit_signal("speed_add_requested",speed_adds)
	emit_signal("speed_mult_requested",speed_mults)
	var final_move_speed = base_move_speed
	
	for speed_add in speed_adds:
		final_move_speed += speed_add
	
	for speed_mult in speed_mults:
		final_move_speed *= speed_mult
	
	velocity.x = move_toward(velocity.x, direction.x * final_move_speed, final_move_speed)

func apply_velocity(vector : Vector2):
	velocity += vector



func jump():
	if air_state == GROUNDED:
		velocity.y -= base_jump_speed
		move_and_slide()
	
