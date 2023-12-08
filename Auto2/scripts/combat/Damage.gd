extends Resource
class_name Damage

@export var damage_value : float = 0
@export_enum("Phys","Heat","Electric","Cold") var affinity : int = 0
@export var tracking : float = 10
@export var penetration : float = 0
@export var effects : Array[PackedScene] = []

var source : Character

