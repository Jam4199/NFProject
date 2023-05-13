extends Level

@onready var uno = get_node("%triangle")
@onready var dos = get_node("%bottomright")
@onready var tres = get_node("%recty")
@onready var shi = get_node("%Circle")

func start():
	
	wavetimer.start(3)
	
	await wavetimer.timeout
	var one = create_tween()
	one.tween_property(uno, "position", Vector2(0,0) ,2)
	wavetimer.start(15)
	
	await wavetimer.timeout
	var two = create_tween()
	two.tween_property(dos, "position", Vector2(0,0) ,2)
	wavetimer.start(15)
	
	await wavetimer.timeout
	var three = create_tween()
	three.tween_property(tres, "position", Vector2(0,0) ,2)
	wavetimer.start(15)
	
	await wavetimer.timeout
	var four = create_tween()
	four.tween_property(shi, "position", Vector2(120,120) ,2)
	
	
	
	wavetimertext.text = "DANGER! :"
	wavetimer.start(60)
	
	await wavetimer.timeout
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.has_method("enrage"):
			enemy.enrage()
