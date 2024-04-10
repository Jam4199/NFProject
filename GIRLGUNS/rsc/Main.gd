extends Node
class_name Main

const PLAYERSCENE : PackedScene = preload("res://rsc/player/Player.tscn")
const WORLDSCENE : PackedScene = preload("res://rsc/world/World.tscn")

@onready var world_canvas : CanvasLayer = get_node("World")
@onready var ui_canvas : CanvasLayer = get_node("UI")
@onready var title_screen : CanvasLayer = get_node("TitleScreen")
@onready var centerifier : Camera2D = get_node("World/Centerifier")

func _ready() -> void:
	Globals.main = self
	Globals.records = get_node("Records")
	title_screen.connect("game_start", Callable(self,"new_game_start"))
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
	centerifier.enabled = false
	create_new_player()
	create_new_world(WORLDSCENE)
	player_to_world()
	var weapon : Weapon = Globals.player.weapon_manager.add_weapon(load("res://rsc/player/weapons/Aster/AsterWeapon.tscn"))
	weapon.update_stats()
	Globals.player.movement_input = true
	Globals.player.attack_input = true
	Globals.world.world_camera.follow_point = Globals.player
	Globals.world.runprogress.start()
	ui_canvas.visible = true


func game_reset():
	Globals.world.queue_free()
	centerifier.enabled = true
	title_screen.visible = true
	ui_canvas.visible = false
