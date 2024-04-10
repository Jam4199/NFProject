extends Control
class_name PauseMenu

func _ready() -> void:
	visible = false
	Globals.pausemenu = self
	var button : Button = get_node("Panel/Unpause")
	button.connect("pressed",Callable(self,"player_unpause"))
	var retry_button = get_node("Panel/Return")
	retry_button.connect("pressed", Callable(self,"player_return"))

func player_unpause():
	Globals.world.process_mode = PROCESS_MODE_INHERIT
	visible = false

func player_return():
	visible = false
	Globals.return2title()
