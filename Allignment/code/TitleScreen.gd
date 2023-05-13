extends Control

@onready var left = get_node("%Left")
@onready var right = get_node("%Right")
@onready var start = get_node("%Start")
@onready var level = get_node("%Level")
@onready var tree = get_node("%AnimationTree")

var level_select : int = 1
var away : bool = false
signal start_game(level : int)

func _ready() -> void:
	left.connect("pressed", Callable(self, "level_left"))
	right.connect("pressed", Callable(self, "level_right"))
	start.connect("pressed", Callable(self, "start_level"))
	

func level_left():
	if away:
		return
	level_select -= 1
	if level_select < 1:
		level_select = 4
	update_text()

func level_right():
	if away:
		return
	level_select += 1
	if level_select > 4:
		level_select = 1
	update_text()

func start_level():
	if away:
		return
	emit_signal("start_game", level_select)
	


func update_text():
	level.text = "[center]" + str(level_select) + "[/center]"

func enter():
	away = false
	tree.set("parameters/Transition/transition_request", "onscreen")

func leave():
	away = true
	tree.set("parameters/Transition/transition_request", "offscreen")
