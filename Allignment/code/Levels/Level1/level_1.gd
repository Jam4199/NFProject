extends Level

@onready var SpinnyOne = get_node("%SpinnyOne")
@onready var righty = get_node("%RightL")
@onready var lefty = get_node("%LeftL")

func start():
	
	wavetimer.start(3)
	
	await wavetimer.timeout
	var move_spinny = create_tween()
	move_spinny.tween_property(SpinnyOne, "position", Vector2(0,0) ,2)
	
	wavetimer.start(15)
	
	await wavetimer.timeout
	var leftrighty = create_tween()
	leftrighty.parallel().tween_property(righty, "position", Vector2(40,-40) ,2)
	leftrighty.parallel().tween_property(lefty, "position", Vector2(-40,40) ,2)
	
	wavetimertext.text = "DANGER! :"
	wavetimer.start(30)
	
	await wavetimer.timeout
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.has_method("enrage"):
			enemy.enrage()
