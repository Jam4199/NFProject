extends Action
@export var damage := Damage.new()
var knockback : float = 50

func act(caster : Character, target : Character):
	print("cast by " + str(caster) + " toward " + str(target))
	var timer := create_timer()
	timer.start()
	await timer.timeout
	timer.queue_free()
	
	if not caster.is_alive():
		return
	var new_damage = damage.duplicate()
	new_damage.value = caster.attack + 10
	target.take_damage(new_damage)
	target.apply_knockback(knockback,Vector2.from_angle(caster.position.angle_to_point(target.position)))
	

	
	return

func create_timer(wait_time : float = 0.1) -> Timer:
	var new_timer = Timer.new()
	new_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	new_timer.one_shot = true
	new_timer.wait_time = wait_time
	add_child(new_timer)
	return new_timer














