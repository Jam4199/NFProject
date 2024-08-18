extends Node

@onready var combat : Combat = get_node("%Combat")
@onready var a : Team = get_node("Team")
@onready var b : Team = get_node("Team2")

func _ready() -> void:
	GameState.current_combat = combat
	
	combat.load_team(a)
	combat.load_team(b)
	
	combat.state_input("start")
