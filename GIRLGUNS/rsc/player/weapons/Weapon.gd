extends Node2D
class_name Weapon

@export var ui_name : String = "Weapon"
@export_group("Base Stats")
@export var magazine_size : int = 10
@export var rof : float = 12 #fire per second
@export var reload_time : float = 2 #seconds
@export var spread : float = 2 #degrees for both sides
@export var shots : int = 1 #shots per second


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire():
	return
