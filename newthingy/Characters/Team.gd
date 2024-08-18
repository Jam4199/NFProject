extends Node
class_name Team

@onready var team_leader : Character = get_node("Leader").get_child(0)
@onready var team_effects : TeamEffects = get_node("TeamEffects")

@export var team_name : String = "Team"
@export var base_morale : float = 1000
@export var faction : factions = factions.PLAYER
enum factions {PLAYER = -1, ENEMY = 1}
@export var team_offense : float = 100
@export var team_defense : float = 50
@export var leader_defense : float = 50



@export_enum("Neutral","Defensive","Aggressive") var form : int = 0
var character_list : Array[Character] = []


var max_morale : float = 1000
var current_morale : float = 1000

var attack_buff : float = 1
var defense_buff : float = 1
var effect_tags : Array[String]

func _ready() -> void:
	max_morale = base_morale
	current_morale = current_morale
	var children = get_children()
	
	for character in children:
		if character is Character:
			add_character(character)
			
	
	return

func add_character(character : Character):
	character_list.append(character)
	if not character in get_children():
		add_child(character)

func get_all_characters() -> Array[Character]:
	var list : Array[Character] = character_list.duplicate()
	list.append(team_leader)
	return list


func load_formation():
	return
  
func turn_start():
	
	attack_buff = 1
	defense_buff = 1
	team_effects.input("turn_start")

func combat_start():
	team_effects.input("combat_start")
	


func return_characters():
	for character in character_list:
		character.get_parent().remove_child(character)
		add_child(character)
	team_leader.get_parent().remove_child(team_leader)
	get_node("Leader").add_child(team_leader)
	
	return

func recieve_damage(recieved_offense : float) -> float:
	var missing_hp : float = 0
	for character in character_list:
		missing_hp += character.max_hp - character.current_hp
	missing_hp += (team_leader.max_hp - team_leader.current_hp) * (recieved_offense / leader_defense)
	var damage_dealt = (missing_hp) * (recieved_offense / (team_defense + 100.0))
	if effect_tags.has("marked"):
		damage_dealt *= 1.20
	current_morale -= damage_dealt
	return damage_dealt

func battle_start():
	for character in character_list:
		character.attack *= attack_buff
		character.defense *= defense_buff
	team_leader.attack *= attack_buff
	team_leader.defense *= defense_buff

func battle_end():
	return_characters()
	for character in character_list:
		character.battle_end()

func team_wipe():
	return

