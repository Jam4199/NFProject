extends Node
class_name MGInfo




@export var base_data : MGData = MGData.new()
@export var casual_name : String = "Name"
@export var mg_name : String = "MG"

@onready var behavior = get_node("Behavior")

@export_group("Meters")
@export var hope_thresholds : Array[int] = []
@export var socials_thresholds : Array[int] = []
@export var studies_thresholds : Array[int] = []
@export var solidarity_thresholds : Array[int] = []

var current_data : MGData
var meter_thresholds : Array[Array] = [hope_thresholds,]

func _ready() -> void:
	meter_thresholds = [hope_thresholds, socials_thresholds, studies_thresholds, solidarity_thresholds]
	reset()

func reset():
	current_data = base_data.duplicate()

func tic():
	return



