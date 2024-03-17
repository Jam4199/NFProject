extends CanvasLayer

@onready var button : Button = get_node("Control/Button")
signal game_start

func _ready() -> void:
	button.connect("pressed",Callable(self,"start_game"))

func open():
	visible = true

func start_game():
	visible = false
	emit_signal("game_start")
