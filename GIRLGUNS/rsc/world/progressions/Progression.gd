@tool
extends Resource
class_name Progression

@export var text : String = ""
@export var delay : float = 5
@export var duration : Vector2i = Vector2i(0,30)
@export var enemies : Array[PackedScene] = [] : set = set_enemies
@export var spawn_count : Array[int] : set = set_spawn_count

func set_enemies(new_set):
	spawn_count.resize(new_set.size())
	enemies = new_set
	notify_property_list_changed()

func set_spawn_count(new_set):
	enemies.resize(new_set.size())
	spawn_count = new_set
	notify_property_list_changed()
