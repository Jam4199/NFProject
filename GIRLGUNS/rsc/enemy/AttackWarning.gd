extends Node2D
class_name AttackWarning

@export var warning_time : float = 1
@export var warning_length : float = 100
@export var warning_width : float = 60

@onready var wide : Line2D = get_node("Wide")
@onready var narrow : Line2D = get_node("Narrow")

var active : bool = true
var current_time : float = 0

func _ready() -> void:
	visible = false
	start() #use for testing
	return

func _physics_process(delta: float) -> void:
	if not active:
		return
	current_time += delta
	narrow.width = floori((warning_width/10.0) + (warning_width * ((9.0/10.0)*(current_time/warning_time)) ))
	if current_time >= warning_time:
		end()

func start():
	visible = true
	for node in [wide,narrow]:
		node.points[1].x = warning_length
	wide.width = warning_width
	narrow.width = warning_width/10
	current_time = 0
	active = true

func end():
	visible = false
	active = false
	start() #use for testing
