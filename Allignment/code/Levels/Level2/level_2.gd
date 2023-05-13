extends Level

@onready var fourdukes : Node2D = get_node("%FourDukes")
@onready var TwinnyL : Node2D = get_node("%TwinnyL")
@onready var TwinnyR : Node2D = get_node("%TwinnyR")


func start():
	wavetimer.start(3)
	await wavetimer.timeout
	fourdukes.visible = true
	
	wavetimer.start(15)
	await wavetimer.timeout
	var tween : Tween = create_tween()
	tween.parallel().tween_property(TwinnyL,"position", Vector2(0,0), 2)
	tween.parallel().tween_property(TwinnyR,"position", Vector2(0,0), 2)
	
	wavetimertext.text = "DANGER! :"
	wavetimer.start(30)
	
	await wavetimer.timeout
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.has_method("enrage"):
			enemy.enrage()
	
	
