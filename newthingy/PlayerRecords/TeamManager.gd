extends Node


@export var team_count : int = 0
@export var teamdatas : Array[TeamData] = [TeamData.new(), TeamData.new(), TeamData.new(), TeamData.new()]

@export_group("Inventory")
@export var vessels : Array[int]
@export var elements : Array[int]
@export var roster : Array[int]




@onready var teams : Array[Team] = [get_node("Team0"),get_node("Team1"), get_node("Team2"),get_node("Team3")]


func _ready() -> void:
	
	vessels.resize(Constants.vessel.size())
	elements.resize(Constants.element.size())
	roster.resize(Constants.chara.size())
	for i in vessels:
		i = 0
	for i in elements:
		i = 0
	for i in roster:
		i = 0
	for team in teamdatas:
		if team != null:
			team.update_uses()



func new_start():
	team_count = 1
	for team in teamdatas:
		team.clear()
	teamdatas[0].set_leader(Constants.leaders.HRO)
	
	for array in [vessels,elements,roster]:
		for n in range(0,array.size()):
			array[n] = 0



