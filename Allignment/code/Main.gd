extends Node

@onready var titlescreen = get_node("TitleScreen")
@onready var cover = get_node("Cover")
@onready var levelarea = get_node("LevelArea")

var current_level : Level

var level_list : Array = [
	"res://code/Levels/Level1/level_1.tscn",
	"res://code/Levels/Level2/level_2.tscn",
	"res://code/Levels/Level3/level_3.tscn",
	"res://code/Levels/Level4/level_4.tscn"
]



func _ready() -> void:
	titlescreen.connect("start_game", Callable(self,"start_game"))


func start_game(level : int):
	var new_level = load(level_list[level - 1])
	current_level = new_level.instantiate()
	levelarea.add_child(current_level)
	current_level.connect("game_over", Callable(self,"game_end"))
	titlescreen.leave()
	cover.visible = false
	

func game_end():
	current_level.queue_free()
	cover.visible = true
	titlescreen.enter()
