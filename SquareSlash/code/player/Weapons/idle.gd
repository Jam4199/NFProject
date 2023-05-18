extends State

func input(command: String):
	match command:
		"melee_press":
			controller.transition("melee", command)
		"range_press":
			controller.transition("ranged", command)
