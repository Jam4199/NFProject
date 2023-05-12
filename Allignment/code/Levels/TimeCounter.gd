extends RichTextLabel

@onready var timer : Timer = get_node("%Timer")
func _process(delta: float) -> void:
	text = str(floor(timer.time_left))
	
