extends Node
class_name Team

@export_enum("Passive","Defensive","Aggressive") var form : int = 0
var team_array : Array[Dictionary] = []

func _ready() -> void:
	var unit_list = get_node("Units").get_children()
	for unit in unit_list:
		if unit is Unit:
			add_unit(unit)

	
	return

func add_unit(unit : Unit , slot : int = 0):
	
	var unit_info : Dictionary = {}
	unit_info["unit"] = unit
	unit_info["position"] = slot
	
	if unit_info["position"] <= 0 or unit_info["position"]> 9 :
		unit_info["position"] = unit.default_position
	
	team_array.append(unit_info)



func load_formation():
	return
  
func return_units():
	for unit_info in team_array:
		unit_info["unit"].get_parent().remove_child(unit_info["unit"])
		get_node("Units").add_child(unit_info["unit"])
		
	return
