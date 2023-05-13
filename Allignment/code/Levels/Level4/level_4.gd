extends Level

@onready var uno = get_node("%og")
@onready var dos = get_node("%copy")
@onready var tres = get_node("%vert")
@onready var shi = get_node("%hori")
@onready var fiddy = get_node("%bounce")

func start():
	
	wavetimer.start(3)
	
	await wavetimer.timeout
	var one = create_tween()
	one.tween_property(uno, "position", Vector2(0,0) ,2)
	wavetimer.start(15)
	
	await wavetimer.timeout
	var two = create_tween()
	two.tween_property(dos, "position", Vector2(-2,46) ,2)
	wavetimer.start(15)
	
	await wavetimer.timeout
	var three = create_tween()
	three.tween_property(tres, "position", Vector2(0,0) ,2)
	three.tween_property(shi, "position", Vector2(0,0) ,2)
	wavetimer.start(15)
	
	await wavetimer.timeout
	var five = create_tween()
	five.tween_property(fiddy, "position", Vector2(0,0) ,2)
	
	
	
	wavetimertext.text = "DANGER! :"
	wavetimer.start(60)
	
	await wavetimer.timeout
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.has_method("enrage"):
			enemy.enrage()
