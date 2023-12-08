extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace player actions with custom gameplay actions.
	look_at(get_global_mouse_position())
	var direction : Vector2 = Vector2(Input.get_axis("player_left", "player_right"),Input.get_axis("player_up", "player_down")).normalized()
	if direction != Vector2(0,0):
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
