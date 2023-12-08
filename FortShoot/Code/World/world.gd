extends Node2D

@export var game_cam : Camera2D
@export var player : CharacterBody2D

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_cam != null and player != null:
		game_cam.global_position = player.global_position
	pass
