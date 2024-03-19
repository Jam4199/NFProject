extends Control
class_name GameOver

@onready var retry_button = get_node("Panel/Return")


func _ready() -> void:
	Globals.gameover = self
	visible = false
	retry_button.connect("pressed", Callable(Globals,"return2title"))
