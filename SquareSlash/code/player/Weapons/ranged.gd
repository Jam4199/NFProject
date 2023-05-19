extends State

@export var charge_time : float = 1.5

var current_charge : float = 0
var full_charged : bool = false


func proc(delta : float):

	current_charge += delta
	if current_charge >= charge_time:
		full_charge():
	return

func entered():
	charge_time = 0
	full_charged = false
	
func full_charge():
	full_charged = true


func input(command: String):
	match command:
		"range_released":
			if full_charged:
				print("do the charge_attack")
			else:
				controller.transition("idle")

			
			