extends Node

@onready var titlescreen = get_node("TitleScreen")
@onready var cover = get_node("Cover")
@onready var levelarea = get_node("LevelArea")

var current_level : Level
var current_level_index : int

var level_list : Array = [
	"res://code/Levels/Level1/level_1.tscn",
	"res://code/Levels/Level2/level_2.tscn",
	"res://code/Levels/Level3/level_3.tscn",
	"res://code/Levels/Level4/level_4.tscn"
]



func _ready() -> void:
	titlescreen.connect("start_game", Callable(self,"start_game"))


func start_game(level : int):
	titlescreen.away= true
	cover.visible = true
	current_level_index = level
	var new_level = load(level_list[level - 1])
	current_level = new_level.instantiate()
	await get_tree().create_timer(0.5).timeout
	levelarea.add_child(current_level)
	current_level.connect("game_over", Callable(self,"game_end"))
	current_level.connect("retry_level", Callable(self,"reset_game"))
	titlescreen.leave()
	uncover()

func reset_game():
	cover.visible = true
	current_level.queue_free()
	start_game(current_level_index)

func game_end():
	current_level.queue_free()
	cover.visible = true
	titlescreen.enter()


func uncover():
	cover.visible = true
	cover.modulate = Color(0,0,0,1)
	await get_tree().create_timer(0.2).timeout
	var tween : Tween = create_tween()
	tween.tween_property(cover,"modulate",Color(0,0,0,0),.8)
	await get_tree().create_timer(0.8).timeout
	cover.visible = false
	cover.modulate = Color(0,0,0,1)
	
