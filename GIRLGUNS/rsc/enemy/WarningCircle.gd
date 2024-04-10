extends Node2D
class_name WarningCircle

@export var warning_time : float = 1
@export var warning_radius: float = 100
@export var auto_start : bool = false

@onready var inner : CircleThing = get_node("Inner")
@onready var outer : CircleThing = get_node("Outer")

var active : bool = true
var current_time : float = 0

func _ready() -> void:
	visible = false
	if auto_start:
		call_deferred("start")
	return

func _physics_process(delta: float) -> void:
	if not active:
		return
	current_time += delta
	inner.radius = floori((warning_radius/10.0) + (warning_radius * ((9.0/10.0)*(current_time/warning_time)) ))
	inner.queue_redraw()
	if current_time >= warning_time:
		end()

func start():
	visible = true
	outer.radius = warning_radius
	inner.radius = warning_radius/10
	outer.queue_redraw()
	inner.queue_redraw()
	current_time = 0
	active = true


func end():

	visible = false
	active = false
	#start() #use for testing
