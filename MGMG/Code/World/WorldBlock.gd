extends Area2D
class_name WorldBlock

@onready var health_bar : TextureProgressBar = get_node("%HealthBar")

var max_hp : float = 100 : set = set_max_hp
var hp : float = 100 : set = set_hp

func read_data(blockdata : BlockData):
	health_bar.max_value = blockdata.max_hp
	health_bar.value = blockdata.hp

func set_max_hp(new_max_hp : float):
	max_hp = new_max_hp
	health_bar.max_value = max_hp
	set_hp(new_max_hp)

func set_hp(new_hp : float):
	hp = new_hp
	health_bar.value = hp
	
