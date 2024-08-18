extends Node

const team_scene = preload("res://Characters/Team.tscn")

@onready var playerteams : Node = get_node("PlayerTeams")
@onready var enemyteams : Node = get_node("EnemyTeams")

func reset_teams():
	for node in playerteams.get_children():
		node.queue_free()
	for node in enemyteams.get_children():
		node.queue_free()
	

func load_player_team(data : TeamData) -> Team:
	var new_team : Team = team_scene.instantiate()
	playerteams.add_child(new_team)
	return new_team
