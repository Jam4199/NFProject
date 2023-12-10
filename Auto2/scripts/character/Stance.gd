extends Node2D
class_name Stance

@onready var controller : Controller = get_node("Controller")
var actions : Array
var passives : Array

@export var default_range : float = 10


@export_group("Stat_Addition")
@export var attack_add : float = 0
@export var defense_add : float = 0
@export var max_health_add : float = 0
@export var custom_stat_adds : Dictionary = {}


@export_group("Stat_Multiplers")
@export var move_speed_mult : float = 1
@export var attack_speed_mult : float = 1
@export var attack_mult : float = 1
@export var defense_mult : float = 1
@export var max_health_mult : float = 1
@export var custom_stat_mults : Dictionary = {}

@export_group("Affinity_Modifiers")
@export var red : float

func _ready() -> void:
	
	
	for node in get_node("Actions").get_children():
		if node is Node2D:
			actions.append(node)
	
	for node in get_node("Passives").get_children():
		if node is Node2D:
			passives.append(node)
	



