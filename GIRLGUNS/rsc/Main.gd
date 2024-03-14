extends Node
class_name Main

const PLAYERSCENE : PackedScene = preload("res://rsc/player/Player.tscn")
const WORLDSCENE : PackedScene = preload("res://rsc/world/World.tscn")

@onready var world_canvas : CanvasLayer = get_node("World")
@onready var ui_canvas : CanvasLayer = get_node("UI")
@onready var title_screen : CanvasLayer = get_node("TitleScreen")

func _ready() -> void:
	Globals.records = get_node("Records")
	open_title()

func open_title():
	title_screen.visible = true

func create_new_player()-> Player:
	var new_player = PLAYERSCENE.instantiate()
	Globals.player = new_player
	return new_player

func create_new_world(world_scene : PackedScene)-> World:
	var new_world : World = world_scene.instantiate()
	world_canvas.add_child(new_world)
	new_world.initialize()
	Globals.world = new_world
	return new_world

func player_to_world():
	if Globals.player == null or Globals.world == null:
		return
	Globals.world.spawn_player()

func new_game_start():
	var placeholder_scene = null #placeholder
	create_new_player()
	create_new_world(placeholder_scene)
	player_to_world()

