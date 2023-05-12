extends Level

@onready var fourdukes : Node2D = get_node("%FourDukes")

func start():
	wavetimer.start(3)
	await wavetimer.timeout
	fourdukes.visible = true
	return

