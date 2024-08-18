extends Node2D

@onready var worldcontainer : SubViewportContainer = get_node("%WorldContainer")
@onready var worldmap : WorldMap = get_node("%WorldMap")
@onready var time_progress : TimeProgress = get_node("%TimeProgress")
@onready var city_data : CityData = get_node("%CityData")
@onready var mg_progress : MGProgress = get_node("%MGProgress")
@onready var familiars : = get_node("%Familiars")
@onready var saves : = get_node("%Saves")


var mouse_state : MOUSE_STATES = MOUSE_STATES.FREE
enum MOUSE_STATES {FREE, HL , HR}

var control_state : CONTROL_STATES = CONTROL_STATES.FREE
enum CONTROL_STATES {FREE, WSCROLL}


var wscroll_previous := Vector2(0,0)

func _ready() -> void:
	
	for tic_connectee in [city_data]:
		time_progress.connect("tic", Callable(tic_connectee,"tic"))

func _process(delta: float) -> void:
	
	if worldmap.mouse_in_map:
		if Input.is_action_just_pressed("scroll_up"):
			worldmap.zoom_in()
		if Input.is_action_just_pressed("scroll_down"):
			worldmap.zoom_out()
	
	match control_state:
		CONTROL_STATES.FREE:
			if Input.is_action_just_pressed("RMB") and worldmap.mouse_in_map:
				control_state = CONTROL_STATES.WSCROLL
				wscroll_previous = get_global_mouse_position()
				
		CONTROL_STATES.WSCROLL:
			if not Input.is_action_pressed("RMB"):
				control_state = CONTROL_STATES.FREE
			else:
				var velocity : Vector2 = get_global_mouse_position() - wscroll_previous
				wscroll_previous = get_global_mouse_position()
				worldmap.camera.position -= velocity / worldmap.camera.zoom.x
	
	pass

