extends Control

func _ready() -> void:
	get_node("%Unpause").connect("pressed", Callable(self,"unpause_game"))
	get_node("%PauseReturn").connect("pressed", Callable(self, "quit_level"))
	get_node("%Retry").connect("pressed", Callable(self,"retry"))

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("pause"):
		pause_game()
	
	return

func pause_game():
	print("pause please")
	get_tree().paused = true
	self.visible = true

func unpause_game():
	print("unpause pls")
	visible = false
	get_tree().paused = false

func quit_level():
	get_tree().paused = false
	owner.emit_signal("game_over")

func retry():
	get_tree().paused = false
	owner.emit_signal("retry_level")

