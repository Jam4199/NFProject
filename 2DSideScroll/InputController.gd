extends Node
class_name InputController

var dpad : Dictionary = {
	"(-1, 1)" = 1,
	"(0, 1)" = 2,
	"(1, 1)" = 3,
	"(-1, 0)" = 4,
	"(0, 0)" = 5,
	"(1, 0)" = 6,
	"(-1, -1)" = 7,
	"(0, -1)" = 8,
	"(1, -1)" = 9
	
}
var dpad_current : int = 5 

var dpad_enabled : bool = true
var action_enabled : bool = true

@export var label : Label 
@export var body : CharacterBody2D

signal move_ordered(order : Vector2)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	dpad_current = dpad[str(get_dpad())]
	
	if label != null:
		label.text = str(dpad_current)
	
	if Input.is_action_pressed("B"):
		body.jump()

func get_dpad() -> Vector2:
	var direction := Vector2(0, 0)
	if not dpad_enabled:
		return direction
	direction.x = round(Input.get_axis("left", "right"))
	direction.y = round(Input.get_axis("up", "down"))
	return direction



