extends Node2D
class_name WorldMap

@onready var camera : Camera2D = get_node("%Camera")

var mouse_in_map : bool = false
var zoom_per_scroll : float = 0.05
var current_zoom : float = 1.0
var max_zoom : float = 1.4
var min_zoom : float = 0.6

func _on_map_mouse_detect_mouse_entered() -> void:
	mouse_in_map = true

func _on_map_mouse_detect_mouse_exited() -> void:
	mouse_in_map = false

func zoom_in():
	if current_zoom < max_zoom:
		current_zoom += zoom_per_scroll
	update_zoom()
	return

func zoom_out():
	if current_zoom > min_zoom:
		current_zoom -= zoom_per_scroll
	update_zoom()
	return

func update_zoom():
	camera.zoom = Vector2(current_zoom,current_zoom)

func position_to_block(pos : Vector2) -> int:
	var hori : int = floori(pos.x/10)
	var vert : int = floori(pos.y) % 10
	return ((hori * 10) + vert)
