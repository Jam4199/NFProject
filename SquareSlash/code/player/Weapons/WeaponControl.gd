extends Node2D

@onready var sord = get_node("Sord")
@onready var gan = get_node("Gan")


var states : Dictionary = {}
var current_state : State


@export var base_melee_combo : int = 0
@export var base_range_combo : int = 3


var cooldown : float

var combocount : int

var melee_charge_required : float = 1
var melee_charging : bool = false
var melee_charge_time : float = 0
var melee_charged : bool = false

var ranged_charging : bool = false

func _ready():
	for state in get_node("States").get_children():
		state.controller = self
		states[state.name] = state
	current_state = states["idle"]
	

func transition(new_state : String, command : String = ""):
	
	if states.has(new_state) == false:
		print("state not found")
		return
	
	current_state.exit()
	current_state = states[new_state]
	current_state.entered()



func attack_command(command : String):
	current_state.input(command)


func _physics_process(delta : float):
	if cooldown > 0:
		cooldown -= delta
	
	current_state.proc(delta)

