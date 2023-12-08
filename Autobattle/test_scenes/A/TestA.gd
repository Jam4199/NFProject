extends Node2D

@onready var field : Field = get_node("Field")
@onready var leftteam : Team = get_node("LeftTeam")
@onready var rightteam : Team = get_node("RightTeam")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	field.deploy_teams(leftteam,rightteam)
	field.combat_start()
	pass # Replace with function body.



