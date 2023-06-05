extends Area2D

signal weapon_fire

func _ready() -> void:
	connect("weapon_fire", Callable(Settings,"weapon_fired"))
	connect("input_event", Callable(self,"_on_input_event"))

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if event.is_action_pressed("weapon_fire"):
		emit_signal("weapon_fire")
	


