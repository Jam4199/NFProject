extends Node
class_name Team

@export_enum("Passive","Defensive","Aggressive") var form : int = 0
var team_array : Array[Dictionary] = []

func _ready() -> void:
	var character_list = get_node("Units").get_children()
	for character in character_list:
		if character is Character:
			add_character(character)

	
	return

func add_character(character : Character , slot : int = 0):
	
	var character_info : Dictionary = {}
	character_info["character"] = character
	character_info["position"] = slot
	
	if character_info["position"] <= 0 or character_info["position"]> 9 :
		character_info["position"] = character.default_position
	
	team_array.append(character_info)



func load_formation():
	return
  
func return_characters():
	for character_info in team_array:
		character_info["character"].get_parent().remove_child(character_info["character"])
		get_node("Units").add_child(character_info["character"])
		
	return
